//
//  JPMC_20220131_LeifAshley_NYCSchoolsApp.swift
//  JPMC-20220131-LeifAshley-NYCSchools
//
//  Created by Leif Ashley on 1/31/22.
//

import SwiftUI
import Combine

@main
struct JPMC_20220131_LeifAshley_NYCSchoolsApp: App {
    
    var body: some Scene {
        WindowGroup {
            SchoolsView().environmentObject(AppState.current)
        }
    }
    
    init() {
        AppState.current.refreshAll()
    }
}

enum DataRefreshState {
    case idle
    case refreshing
}


/// Overall application state container as a singleton but also used in as an environment object.
///  This class acts as a fetcher for it's state data and caches the data between view state change.
class AppState: ObservableObject {
    @Published var schoolsList: [SchoolShortViewModel] = []
    @Published var satScoresList: [SatScoreViewModel] = []
    
    @Published var schoolsListFetchStatus: DataRefreshState = .idle
    @Published var satScoresFetchStatus: DataRefreshState = .idle
    
    var numOfTestersAvg = 1
    var mathAvgScore = 2
    var readingAvgScore = 3
    var writingAvgScore = 4
    
    static public var current = AppState()
    private init() {}
    
    func refreshAll() {
        AppState.refreshSchoolShortList()
        refreshSatScoresList()
    }
    
    
    /// Loads the school view model list used in the initial landing view for all the schools.
    /// This data was a bit too large to pull back in bulk
    static func refreshSchoolShortList() {
        let controller = SchoolDataController()
        
        controller.fetchSchoolShortList { schoolsList in
            log.info("Fetched \(schoolsList.count) schools (short)")
            
            log.info("refreshSchoolShortList4 \(Thread.current.extendedDetails)")
            DispatchQueue.main.async {
                log.info("refreshSchoolShortList5 \(Thread.current.extendedDetails)")
                AppState.current.schoolsListFetchStatus = .idle
                AppState.current.schoolsList = schoolsList
            }
        }
    }
    
    
    /// Loads all the sat scores at once since the data set is small, around 6 fields for 440 objects
    func refreshSatScoresList() {
        let controller = SchoolDataController()
        controller.fetchSatScoresList { satScoresList in
            log.info("Fetched \(satScoresList.count) Sat Scores")
            
            self.calculateSatAverages(satScoresList)
            
            DispatchQueue.main.async {
                AppState.current.satScoresFetchStatus = .idle
                self.satScoresList = satScoresList
            }
        }
      
    }
    
    
    /// Calculates the averages for the SAT scores to get a comparison for a given school against that average.
    /// - Parameter satScoresList: List of SAT scores view models
    private func calculateSatAverages(_ satScoresList: [SatScoreViewModel]) {
        var numOfTestersAvg = 0
        var mathAvgScore = 0
        var readingAvgScore = 0
        var writingAvgScore = 0
        
        for score in satScoresList {
            numOfTestersAvg += score.numOfTesters
            mathAvgScore += score.mathAvgScore
            readingAvgScore += score.readingAvgScore
            writingAvgScore += score.writingAvgScore
        }
        
        self.numOfTestersAvg = numOfTestersAvg / satScoresList.count
        self.mathAvgScore = mathAvgScore / satScoresList.count
        self.readingAvgScore = readingAvgScore / satScoresList.count
        self.writingAvgScore = writingAvgScore / satScoresList.count
    }
    
    func fetchSchool(dbn: String) {
        let controller = SchoolDataController()
        
        controller.fetchSchoolFull(dbn: dbn) { schoolFull in
            
        }
    }
}
