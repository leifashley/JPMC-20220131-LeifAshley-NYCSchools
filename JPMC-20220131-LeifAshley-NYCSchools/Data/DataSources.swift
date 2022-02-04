//
//  Datasources.swift
//  CommandLineRunner
//
//  Created by Leif Ashley on 2/2/22.
//

import Foundation
import Alamofire


/// Support for building the correct URL strings that might/will change over time.
/// - Sets a base default as a fallback configuration for host, scheme, etc.
/// - On first instantiation, checks the config to see if the default is in use, if so, tries to pull settings from datasource.plist
/// - If the plist load fails for any reason, the default settings stay in tact to the URLs can attempt to fetch data.

class AppDatasource {
    static let datasourcePlist = "datasource"
    
    /// Internal configuration used for the URLComponents results
    class DatasourceConfig: Codable, CustomStringConvertible {
        static let defaultScheme = "https"
        static let defaultHost = "data.cityofnewyork.us"
        static let defaultSchoolsPath = "/resource/s3k6-pzi2.json"
        static let defaultSatScoresPath = "/resource/f9bf-2cp4.json"
        
        var scheme: String = defaultScheme
        var host: String = defaultHost
        var schoolsPath: String = defaultSchoolsPath
        var satScoresPath: String = defaultSatScoresPath
        var isUsingNetworkForData: Bool = true
        
        var description: String {
            let kvPairs: KeyValuePairs<String, String> = [
                "scheme": scheme,
                "host": host,
                "schoolsPath": schoolsPath,
                "satScoresPath": satScoresPath,
                "isFetchingFromNetwork": String(isUsingNetworkForData)
            ]
            
            return kvPairs.map {"\($0)=\($1)"}.joined(separator: ", ")
        }
    }
    
    static let defaultConfig = DatasourceConfig()
    static var config = defaultConfig
    
    enum ComponentsType {
        case SchoolComponents, SatScoresComponents
    }
    
    /// Uses the default configuration loaded from the datasource.plist or the configuration provided
    init(_ config: DatasourceConfig?) {
        if let config = config {
            AppDatasource.config = config
        } else {
            AppDatasource.checkConfig()
        }
    }
    
    /// Tries a config if the defaults is in use
    private static func checkConfig() {
        if config === defaultConfig {
            AppDatasource.config = loadDatasourceConfig()
        }
    }
    
    
    /// Tries to load a configuration from the PLIST
    /// - Returns: Returns the newly loaded PLIST config or the default if the PLIST failed to decode
    static func loadDatasourceConfig() -> DatasourceConfig {
        let logTitle = "loadDatasourceConfig"
        var result = AppDatasource.config
        
        if let config = Bundle.decodeFromPList(DatasourceConfig.self, forResource: datasourcePlist) {
            log.info(title: logTitle, "Config settings loaded from plist '\(datasourcePlist)'")
            log.info("- \(config)")
            result = config
            
        } else {
            log.error(title: logTitle, "loadDatasourceConfig: Failed to load AppUrlConfig from '\(datasourcePlist)'", error: AppError.unknownError)
        }
        
        return result
    }
    
    
    /// Builds valid URLComponents from the config based on the type requested
    /// - Parameter type: School or SAT URL path
    /// - Returns: Properly prepared URLComponents for network calls
    static func buildComponents(_ type: ComponentsType) -> URLComponents {
        let path = type == .SchoolComponents ? config.schoolsPath : config.satScoresPath
        
        return buildComponents(path: path)
    }
    
    private static func buildComponents(path: String) -> URLComponents {
        var comps = URLComponents()
        
        comps.scheme = config.scheme
        comps.host = config.host
        comps.path = path
        
        return comps
    }
    
    func loadObjectFromJson<T>(type: T.Type, resourceName: String) -> T? where T: Decodable {
        var result: T? = nil
        
        if let object = Bundle.main.loadJson(type: type, resourceName: resourceName) {
            result = object
        } else {
            log.error("loadObjectFromJson - Could not load JSON for resource: \(resourceName), returning empty", error: AppError.unknownError)
        }
        
        return result
    }
}


class SatScoresDatasource: AppDatasource {
    private static let jsonResourceTitle = "satScoresAll"
    
    var urlComps = buildComponents(.SatScoresComponents)
    
    
    /// Fetches all SAT scores, with a network call limit if specified. If network fetching is turned off, then instead will load from the static JSON
    /// - Parameters:
    ///   - limit: limit of json elements to return
    ///   - completion: AppDataResult of the network call with success wrapping the SAT Score data
    func fetchSatScores(limit: Int? = nil, completion: @escaping (AppDataResult<[SatScore]>) -> Void) {
        if AppDatasource.config.isUsingNetworkForData {
            urlComps.queryItems = nil
            
            if let limit = limit {
                urlComps.addQueryString(name: "$limit", value: "\(limit)")
            }
            
            let fetcher = HttpFetcher()
            fetcher.fetchDecodable(of: [SatScore].self, urlComponents: urlComps) { results in
                switch results.result {
                case .success:
                    completion(results)
                case let .failure(error):
                    log.error("SatScoresDatasource", error: error)
                    completion(results)
                }
            }
        } else {
            log.verbose(title: "fetchSatScores.fetch", "Network disabled, loading JSON resource")
            let satScoresList = loadSatScoresListFromJson()
            let r = AppDataResult<[SatScore]>(result: .success(satScoresList))
            
            completion(r)
        }
    }
    
    /// Fetches an SAT score by dnb, with a network call limit if specified. If network fetching is turned off, then instead will load from the static JSON
    /// - Parameters:
    ///   - dbn: score to fetch from the dbn school number
    ///   - completion: AppDataResult of the network call with success wrapping the SAT Score data
    func fetchSatScore(dbn: String, completion: @escaping (AppDataResult<SatScore>) -> Void) {
        if AppDatasource.config.isUsingNetworkForData {
            urlComps.queryItems = nil
            
            urlComps.addQueryString(name: "dbn", value: dbn)
            
            let fetcher = HttpFetcher()
            fetcher.fetchDecodable(of: [SatScore].self, urlComponents: urlComps) { results in
                switch results.result {
                case let .success(scores):
                    if scores.count == 1 {
                        let score = scores[0]
                        let r = AppDataResult<SatScore>(result: .success(score))
                        completion(r)
                    } else {
                        
                    }
                case let .failure(error):
                    log.error("SatScoresDatasource", error: error)
                    let r = AppDataResult<SatScore>(result: .failure(error))
                    completion(r)
                }
            }
        } else {
            log.verbose(title: "fetchSatScore.fetch", "Network disabled, loading JSON resource")
            
            let satScore = loadSatScoreFromJson(dbn: dbn)
            let r = AppDataResult<SatScore>(result: .success(satScore))
            
            completion(r)
        }
        
        
    }
    
    
    /// Bypass call that loads the data from the resources files
    func loadSatScoresListFromJson() -> [SatScore] {
        let resourceName: String = SatScoresDatasource.jsonResourceTitle
        var result: [SatScore] = [SatScore()]
        
        if let list = loadObjectFromJson(type: [SatScore].self, resourceName: resourceName) {
            result = list
        }
        
        return result
    }
    
    /// Bypass call that loads the data from the resources files
    func loadSatScoreFromJson(dbn: String) -> SatScore {
        let resourceName: String = SatScoresDatasource.jsonResourceTitle
        var result = SatScore()
        
        if let list = loadObjectFromJson(type: [SatScore].self, resourceName: resourceName) {
            let filtered = list.filter { $0.dbn == dbn }
            if filtered.count > 0 {result = filtered[0]}
        }
        
        return result
    }
}

///
class SchoolDatasource: AppDatasource {
    private static let jsonResourceTitle = "schoolsAll"
    
    var urlComps = buildComponents(.SchoolComponents)
    
    /// Fetches all schools (short data), with a network call limit if specified. If network fetching is turned off, then instead will load from the static JSON
    /// - Parameters:
    ///   - limit: limit of json elements to return
    ///   - completion: AppDataResult of the network call with success wrapping the SchoolShort data
    func fetchSchoolsShortList(limit: Int? = nil, completion: @escaping (AppDataResult<[SchoolShort]>) -> Void) {
        if AppDatasource.config.isUsingNetworkForData {
            let fetcher = HttpFetcher()
            urlComps.queryItems = nil
            
            urlComps.addQueryString(name: "$select", value: "dbn,school_name,primary_address_line_1,city,state_code,zip,phone_number,fax_number,school_email,website")
            
            if let limit = limit {
                urlComps.addQueryString(name: "&$limit", value: String(limit))
            }
            
            fetcher.fetchDecodable(of: [SchoolShort].self, urlComponents: urlComps) { results in
                switch results.result {
                case .success:
                    completion(results)
                case let .failure(error):
                    log.error("Fetch fetchSchoolsShortList failed", error: error)
                    completion(results)
                }
            }
        } else {
            log.verbose(title: "fetchSchoolsShortList.fetch", "Network disabled, loading JSON resource")
            
            let schoolsShortList = loadSchoolShortListFromJson()
            let r = AppDataResult<[SchoolShort]>(result: .success(schoolsShortList))
            
            completion(r)
        }
        
    }
    
    /// Fetches a school (full data) by dnb, with a network call limit if specified. If network fetching is turned off, then instead will load from the static JSON
    /// - Parameters:
    ///   - dbn: score to fetch from the dbn school number
    ///   - completion: AppDataResult of the network call with success wrapping the SchoolFull data
    func fetchSchoolByDbn(dbn: String, completion: @escaping (AppDataResult<SchoolFull>) -> Void) {
        if AppDatasource.config.isUsingNetworkForData {
            let fetcher = HttpFetcher()
            urlComps.queryItems = nil
            
            urlComps.addQueryString(name: "dbn", value: dbn)
            urlComps.addQueryString(name: "$limit", value: "1")
            
            fetcher.fetchDecodable(of: [SchoolFull].self, urlComponents: urlComps) { results in
                switch results.result {
                case let .success(schoolsList):
                    if schoolsList.count > 0 {
                        let school = schoolsList[0]
                        let r = AppDataResult<SchoolFull>(result: .success(school))
                        completion(r)
                    } else {
                        let error = AppNetworkError.jsonLoadingError(forResource: SchoolDatasource.jsonResourceTitle)
                        log.error("fetchSchoolByDbn failed, wrong school count of \(schoolsList.count)", error: error)
                        
                        let r = AppDataResult<SchoolFull>(result: .failure(error))
                        completion(r)
                    }
                    
                case let .failure(error):
                    log.error("fetchSchoolByDbn failed, fetcher.fetchDecodable", error: error)
                    let r = AppDataResult<SchoolFull>(result: .failure(error))
                    completion(r)
                }
            }
        } else {
            log.verbose(title: "fetchSchoolByDbn.fetch", "Network disabled, loading JSON resource")
        
            let schoolFull = loadSchoolFromJson(dbn: dbn)
            let r = AppDataResult<SchoolFull>(result: .success(schoolFull))
            
            completion(r)
        }
        
        
    }
    
    /// Bypass call that loads the data from the resources files
    func loadSchoolShortListFromJson() -> [SchoolShort] {
        let resourceName: String = SchoolDatasource.jsonResourceTitle
        var result: [SchoolShort] = [SchoolShort()]
        
        if let list = loadObjectFromJson(type: [SchoolShort].self, resourceName: resourceName) {
            result = list
        }
        
        return result
    }
    
    /// Bypass call that loads the data from the resources files
    func loadSchoolFromJson(dbn: String) -> SchoolFull {
        let resourceName: String = SchoolDatasource.jsonResourceTitle
        var result = SchoolFull()
        
        if let list = loadObjectFromJson(type: [SchoolFull].self, resourceName: resourceName) {
            let filtered = list.filter { $0.dbn == dbn }
            if filtered.count > 0 {result = filtered[0]}
        }
        
        return result
    }
    
}



