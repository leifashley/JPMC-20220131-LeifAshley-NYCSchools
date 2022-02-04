//
//  TestView1.swift
//  JPMC-20220131-LeifAshley-NYCSchools
//
//  Created by Leif Ashley on 2/4/22.
//

import SwiftUI
import MapKit

struct SchoolLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct SchoolMapView: View {
    var schoolFull: SchoolFullViewModel?
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
//    @State var annotations: [SchoolLocation]
    @State var annotations: [SchoolLocation]?

    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                    
            VStack {
                if let schoolFull = schoolFull, schoolFull.hasCoordinate {
                    InnerMap(schoolFull: schoolFull)
                } else {
                    Text("Location Not Available")
                }
            }
            .padding(.leading)
            .padding(.trailing)
            .frame(width: .infinity, height: 270) //TODO: needs to be fixed at some point, but if removed, view does not render
            
            Divider()
        }
    }
    
    
    struct InnerMap: View {
        var schoolFull: SchoolFullViewModel
        
        @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        @State var annotations: [SchoolLocation] = []
        
        var body: some View {
            Map(coordinateRegion: $region, annotationItems: annotations) {
                MapMarker(coordinate: $0.coordinate, tint: .red)
            }
            
            .onAppear {
                updateMap()
            }
        }
        
        func updateMap() {
            let coords = CLLocationCoordinate2D(latitude: schoolFull.latitudeOrZero, longitude: schoolFull.longitudeOrZero)
            
            region = MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            annotations = [SchoolLocation(name: schoolFull.name, coordinate: region.center)]
        }
    }
}

struct SchoolMapView_Previews: PreviewProvider {
    static var previews: some View {
        let config = AppDatasource.loadDatasourceConfig()
        config.isUsingNetworkForData = false
        
        let schoolDatasource = SchoolDatasource(config)
        
    
        let dbn = "01M292"
        let schoolFull = SchoolFullViewModel(schoolDatasource.loadSchoolFromJson(dbn: dbn))
        
        return SchoolMapView(schoolFull: schoolFull).environmentObject(AppState.current)
        
    }
}
