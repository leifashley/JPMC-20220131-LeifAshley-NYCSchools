//
//  DataControllers.swift
//  JPMC-20220131-LeifAshley-NYCSchools
//
//  Created by Leif Ashley on 2/3/22.
//

import Foundation



/// This class sits in between the views and the Datasources
/// Calls here will make the appropriate network calls and then marshal the data models into view models for use by the UI
class SchoolDataController {
    var config: AppDatasource.DatasourceConfig?
    var isUsingNetworkForData = true
    
    init(isFetchingFromNetwork: Bool = true) {
        self.isUsingNetworkForData = isFetchingFromNetwork
        
        let config = AppDatasource.loadDatasourceConfig()
        config.isUsingNetworkForData = isFetchingFromNetwork
    }
    
    //TODO: all these need to handle error states for user notification
    func fetchSchoolShortList(completion: @escaping ([SchoolShortViewModel]) -> Void) {
        let datasource = SchoolDatasource(config)
        
        datasource.fetchSchoolsShortList { result in
            switch result.result {
            case let .success(schoolList):
                let viewModelList = SchoolShortViewModel.toViewModels(schoolList)
                completion(viewModelList)
            case let .failure(error):
                log.error("UISchoolsView fetchSchoolsShortList", error: error)
            }
        }
    }
    
    func fetchSatScoresList(completion: @escaping ([SatScoreViewModel]) -> Void) {
        let datasource = SatScoresDatasource(config)
        
        datasource.fetchSatScores { result in
            switch result.result {
            case let .success(satScoresList):
                let vmList = SatScoreViewModel.toViewModels(satScoresList)
                completion(vmList)
            case let .failure(error):
                log.error("SchoolDataController fetchSatScoresList", error: error)
            }
        }
        
    }
    
    func fetchSchoolFull(dbn: String, completion: @escaping (SchoolFullViewModel?) -> Void) {
        let datasource = SchoolDatasource(config)
        
        datasource.fetchSchoolByDbn(dbn: dbn) { result in
            switch result.result {
            case let .success(schoolFull):
                completion(SchoolFullViewModel(schoolFull))
            case let .failure(error):
                log.error("SchoolDataController fetchSchoolFull", error: error)
                completion(nil)
            }
        }
        
    }
}
