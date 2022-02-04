//
//  ContentView.swift
//  JPMC-20220131-LeifAshley-NYCSchools
//
//  Created by Leif Ashley on 1/31/22.
//

import SwiftUI
import Alamofire

struct SchoolsView: View {
    @EnvironmentObject var appState: AppState
    @State var isListActive = false
    @State var schoolsShortList: [SchoolShortViewModel] = AppState.current.schoolsList
    
    @State private var searchText = ""
    var searchResults: [SchoolShortViewModel] {
        if searchText.isEmpty {
            return appState.schoolsList
        } else {
            let result = appState.schoolsList.filter {
                $0.searchableValue.contains(searchText.lowercased())
            }
            return result
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List(searchResults) { school in
                    NavigationLink(destination: SatSchoolDetailView(schoolShort: school)) {
                        VStack(alignment: .leading) {
                            Text("\(school.name)").font(.headline)
                            Text("\(school.addressStreet)").font(.callout)
                            Text("\(school.addressCSZ)").font(.callout)
                        }
                    }
                    
                    
                }
                .navigationTitle("NYC Schools")
                .refreshable {
                    refreshData()
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search")
            
            }
            
        }
        .navigationViewStyle(.stack)
        .overlay(ProgressSpinnerView(-30).invisible(appState.schoolsListFetchStatus == .idle))
        
    }
    
    func refreshData() {
        log.info("View Refreshing")
        
        DispatchQueue.main.async {
            log.info("SchoolsView main \(Thread.current.extendedDetails)")

            AppState.current.schoolsListFetchStatus = .refreshing
            AppState.current.schoolsList.removeAll()
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            AppState.refreshSchoolShortList()
        }
    }
}

struct ProgressSpinnerView: View {
    var yOffset: CGFloat
    
    init(_ yOffset: CGFloat = -30) {
        self.yOffset = yOffset
    }
    
    var body: some View {
        VStack {
            ProgressView()
                .padding(.bottom, 1)
            Text("Loading...")
        }
        .modifier(ConvexGlassView())
        .offset(y: yOffset)
    }
}

struct GlassSpinnerView: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

struct GlassView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.linearGradient(colors:[.black,.white.opacity(0.75)], startPoint: .top, endPoint: .bottom), lineWidth: 2)
                    .blur(radius: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.radialGradient(Gradient(colors: [.clear,.black.opacity(0.1)]), center: .bottomLeading, startRadius: 300, endRadius: 0), lineWidth: 15)
                    .offset(y: 5)
            )
            .cornerRadius(14)
    }
}

struct ConvexGlassView: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .padding()
//                .frame(height: 50)
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(colors: [.clear,.black.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                .cornerRadius(14)
                .shadow(color: .white.opacity(0.65), radius: 1, x: -1, y: -2)
                .shadow(color: .black.opacity(0.65), radius: 2, x: 2, y: 2)
        } else {
            // Fallback on earlier versions
            content
                .padding()
//                .frame(height: 50)
                .cornerRadius(14)
                .shadow(color: .white, radius: 3, x: -3, y: -3)
                .shadow(color: .black, radius: 3, x: 3, y: 3)
        }
    }
}




struct SchoolsView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolsView().environmentObject(AppState.current)
    }
}
