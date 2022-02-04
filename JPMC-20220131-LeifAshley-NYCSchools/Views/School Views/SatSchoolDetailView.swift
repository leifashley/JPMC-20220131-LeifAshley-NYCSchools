//
//  SatSchoolDetail.swift
//  JPMC-20220131-LeifAshley-NYCSchools
//
//  Created by Leif Ashley on 2/2/22.
//

import SwiftUI

struct SatSchoolDetailView: View {
    @EnvironmentObject var appState: AppState
    @State var schoolFull: SchoolFullViewModel?
    
    @State var schoolShort: SchoolShortViewModel
    @State var satScore: SatScoreViewModel?
    
    @State var schoolFullFetchStatus: DataRefreshState = .idle
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                HeaderCardView(schoolShort: schoolShort, satScore: satScore)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                Divider()
                
                SchoolMapView(schoolFull: schoolFull)
            }
            
        }.onAppear {loadData()}
        .navigationTitle("SAT Scores")
    }
    
    
}

extension SatSchoolDetailView {
    func loadData() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            loadJsonData()
        } else {
            fetchData()
        }
    }
    
    func loadJsonData() {
        let config = AppDatasource.loadDatasourceConfig()
        config.isUsingNetworkForData = false
        
        let schoolDatasource = SchoolDatasource(config)
        let satDatasource = SatScoresDatasource(config)
        
        let dbn = "01M292"
        var satScore = SatScoreViewModel(satDatasource.loadSatScoreFromJson(dbn: dbn))
        let schoolFull = SchoolFullViewModel(schoolDatasource.loadSchoolFromJson(dbn: dbn))
        let schoolShortList = SchoolShortViewModel.toViewModels(schoolDatasource.loadSchoolShortListFromJson())
        
        satScore.satScore.num_of_sat_test_takers = "667"
        schoolFull.school.school_name = "PICKLES"
        
        self.schoolShort = schoolShortList[0]
        self.schoolFull = schoolFull
        self.satScore = satScore
    }
    
    func fetchData() {
        let searchedSatScores = appState.satScoresList.filter { satScore in
            satScore.dbn == schoolShort.dbn
        }
        
        if searchedSatScores.count > 0 {
            DispatchQueue.main.async {
                print("### \(searchedSatScores[0])")
                satScore = searchedSatScores[0]
                schoolShort = schoolShort
            }
        } else {
            log.error("UIView fetchData", error: AppError.unknownError)
        }
        
        loadMatchingSchool(dbn: schoolShort.dbn)
    }
    
    func loadMatchingSchool(dbn: String) {
        // Moved this out instead of inline, too many braces
        let completion:(SchoolFullViewModel?) -> Void = { schoolFull in
            if let schoolFull = schoolFull {
                refreshUI(schoolFull: schoolFull)
            } else {
                //TODO: ui error
            }
        }
        
        DispatchQueue.global().async {
            let controller = SchoolDataController()
            controller.fetchSchoolFull(dbn: dbn, completion: completion)
        }
    }
    
    func refreshUI(schoolFull: SchoolFullViewModel) {
        DispatchQueue.main.async {
            print("SSS: \(schoolFull)")
            self.schoolFull = schoolFull
        }
    }
    
}

struct SatSchoolDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let config = AppDatasource.loadDatasourceConfig()
        config.isUsingNetworkForData = false
        
        let schoolDatasource = SchoolDatasource(config)
        let satDatasource = SatScoresDatasource(config)
        
        let dbn = "01M292"
        var satScore = SatScoreViewModel(satDatasource.loadSatScoreFromJson(dbn: dbn))
        let schoolShortList = SchoolShortViewModel.toViewModels(schoolDatasource.loadSchoolShortListFromJson())
        
        let schoolFull = SchoolFullViewModel(schoolDatasource.loadSchoolFromJson(dbn: dbn))
        
        satScore.satScore.num_of_sat_test_takers = "667"
        schoolFull.school.school_name = "PICKLES"
        
        let view = SatSchoolDetailView(schoolShort: schoolShortList[0])
        view.schoolFull = schoolFull
        view.satScore = satScore
        
        
        return view.environmentObject(AppState.current)
    }
}
