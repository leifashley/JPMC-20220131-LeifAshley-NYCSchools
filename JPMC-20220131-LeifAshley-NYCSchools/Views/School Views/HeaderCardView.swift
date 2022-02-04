//
//  SatViewComponents.swift
//  JPMC-20220131-LeifAshley-NYCSchools
//
//  Created by Leif Ashley on 2/4/22.
//

import SwiftUI

struct HeaderCardView: View {
    var appState: AppState = AppState.current
    var schoolShort: SchoolShortViewModel
    var satScore: SatScoreViewModel?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("\(schoolShort.name)")
                    .font(.headline)
                Text("\(schoolShort.addressStreet)")
                Text("\(schoolShort.addressCSZ)")
            }
            .padding(.bottom, 1)
            
            VStack(alignment: .leading, spacing: 2) {
                if let url = URL(string: "tel:\(schoolShort.phoneNumber)") {
                    Link("\(schoolShort.phoneNumber)", destination: url)
                        .font(.callout)
                } else {
                    Text("Phone: \(schoolShort.phoneNumber)")
                        .font(.callout)
                }
               
                if let url = URL(string: "mailto:\(schoolShort.email)") {
                    Link("\(schoolShort.email)", destination: url)
                        .font(.callout)
                } else {
                    Text("Email: \(schoolShort.email)")
                        .font(.callout)
                }
                
                if let url = URL(string: "http://\(schoolShort.website)") {
                    Link("\(schoolShort.website)", destination: url)
                        .font(.callout)
                } else {
                    Text("\(schoolShort.website)")
                        .font(.callout)
                }
                
                
                Text("Fax: \(schoolShort.faxNumber)")
                    .font(.callout)
            }
            .padding(.bottom, 1)
            
            VStack(alignment: .leading) {
                    Color.clear.frame(height: 0)
                Text("SAT Scores")
                    .font(.headline)
                    .frame(alignment: .leading)
                
                SatViewComponent(appState: appState, satScore: satScore)
                
            }
//            .background(.green)
        }
//        .background(.red)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray)
                .opacity(0.30)
        }
    }
}

struct SatViewComponent: View {
    var appState: AppState
    var satScore: SatScoreViewModel?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(" ")
                    .font(.headline)

                Text("Testers")
                    .font(.callout)
                Text("Math")
                    .font(.callout)
                Text("Reading")
                    .font(.callout)
                Text("Writing")
                    .font(.callout)
            }
            .padding(.leading, 30)
            
            VStack {
                Text("School")
                    .font(.headline)

                if let satScore = satScore {
                    Text("\(satScore.numOfTesters)")
                        .font(.callout)
                    Text("\(satScore.mathAvgScore)")
                        .font(.callout)
                    Text("\(satScore.readingAvgScore)")
                        .font(.callout)
                    Text("\(satScore.writingAvgScore)")
                        .font(.callout)
                } else {
                    Text("-")
                        .font(.callout)
                    Text("-")
                        .font(.callout)
                    Text("-")
                        .font(.callout)
                    Text("-")
                        .font(.callout)
                }
                
            }
            .padding(.leading, 20)
            
            VStack {
                Text("Average")
                    .font(.headline)

                Text("\(appState.numOfTestersAvg)")
                    .font(.callout)
                Text("\(appState.mathAvgScore)")
                    .font(.callout)
                Text("\(appState.readingAvgScore)")
                    .font(.callout)
                Text("\(appState.writingAvgScore)")
                    .font(.callout)
            }
            .padding(.leading, 50)

            
        }
        ///
    }
}

struct HeaderCardView_Previews: PreviewProvider {
    static var previews: some View {
        let config = AppDatasource.loadDatasourceConfig()
        config.isUsingNetworkForData = false
        
        let schoolDatasource = SchoolDatasource(config)
        let satDatasource = SatScoresDatasource(config)
        
        let dbn = "01M292"
        let satScore = SatScoreViewModel(satDatasource.loadSatScoreFromJson(dbn: dbn))
        let schoolShortList = SchoolShortViewModel.toViewModels(schoolDatasource.loadSchoolShortListFromJson())
        
        return HeaderCardView(appState: AppState.current, schoolShort: schoolShortList[0], satScore: satScore)
            .environmentObject(AppState.current)
    }
}
