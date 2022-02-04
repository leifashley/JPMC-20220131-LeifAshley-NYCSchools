//
//  Networking.swift
//  CommandLineRunner
//
//  Created by Leif Ashley on 2/1/22.
//

import Foundation
import Alamofire


/// Application level network error to wrap and insulate the rest of the application from Alamofire results
enum AppNetworkError: Error {
    enum URLFailureReason {
        case urlStringInvalid(url: String)
        case urlInvalid(url: URL)
    }
    
    case invaidURL(reason: URLFailureReason)
    case decodingError(forURL: URL, error: Error)
    case jsonLoadingError(forResource: String)
}

typealias AppDataResult<Success> = HttpResult<Success, AppNetworkError> //TODO just changed from AppNetworkError

struct HttpResult<Success, Failure: Error> {
    public let result: Result<Success, Failure>
}


/// Core fetcher class that only fetches and attempts to decode JSON network data
class HttpFetcher {
    static let logTitle = "HttpFetcher.fetchDecodable"
    
    init() {
        
    }
    
    /// Used for the bulk of the application network calls while URLComponents protects the URL string parts with HTTP encoding
    func fetchDecodable<T: Decodable>(of type: T.Type, urlComponents: URLComponents, completion: @escaping (AppDataResult<T>) -> Void) {
        guard let url = urlComponents.url else {
            let urlString = "\(urlComponents)"
            
            log.error(title: HttpFetcher.logTitle, "Could not build URL '\(urlString)'", error: AppError.unknownError)
            completion( AppDataResult<T>(result: .failure(.invaidURL(reason: .urlStringInvalid(url: urlString)))))
            return
        }
        
        fetchDecodable(of: type, url: url, completion: completion)
    }
    
    /// Mainly used for testing purposes but will take a complete URL string and process data from it
    func fetchDecodable<T: Decodable>(of type: T.Type, urlString: String, completion: @escaping (AppDataResult<T>) -> Void) {
        guard let url = URL(string: urlString) else {
            log.error(title: HttpFetcher.logTitle, "Could not build URL '\(urlString)'", error: AppError.unknownError)
            completion( AppDataResult<T>(result: .failure(.invaidURL(reason: .urlStringInvalid(url: urlString)))))
            return
        }
        
        fetchDecodable(of: type, url: url, completion: completion)
    }
    
    /// Actual alamofire call for processing network requests
    func fetchDecodable<T: Decodable>(of type: T.Type, url: URL, completion: @escaping (AppDataResult<T>) -> Void) {
        log.verbose(title: HttpFetcher.logTitle, "url: \(url)")
        
        AF.request(url)
            .responseDecodable(of: type, completionHandler: { response in
                switch response.result {
                case let .success(schoolArray):
                    completion(AppDataResult<T>(result: .success(schoolArray)))
                case let .failure(error):
                    log.error(title: HttpFetcher.logTitle, "Decode failure fetchDecodable.AF.responseDecodable", error: error)
                    completion( AppDataResult<T>(result: .failure(.decodingError(forURL: url, error: error))))
                }
            })
    }
}
