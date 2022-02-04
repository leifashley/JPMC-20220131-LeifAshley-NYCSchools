//
//  ViewModels.swift
//  CommandLineRunner
//
//  Created by Leif Ashley on 2/2/22.
//

import Foundation


/// SAT Score ViewModel, always returns a value for the score properties since we aren't concerned about missing scores but need a value for other things to do in the UI. Might change this though if showing 0 scores at any time could lead to customer complaints
struct SatScoreViewModel: Identifiable, CustomStringConvertible {
    var id = UUID()
    var satScore: SatScore
    
    var dbn: String {
        return SchoolFormatter.string(satScore.dbn)
    }
    
    var schoolName: String {
        return SchoolFormatter.string(satScore.school_name)
    }
    
    var numOfTesters: Int {
        return SchoolFormatter.int(satScore.num_of_sat_test_takers) ?? 0
    }
    
    var readingAvgScore: Int {
        return SchoolFormatter.int(satScore.sat_critical_reading_avg_score) ?? 0
    }
    
    var mathAvgScore: Int {
        return SchoolFormatter.int(satScore.sat_math_avg_score) ?? 0
    }
    
    var writingAvgScore: Int {
        return SchoolFormatter.int(satScore.sat_writing_avg_score) ?? 0
    }
    
    init(_ satSacore: SatScore) {
        self.satScore = satSacore
    }
    
    // Utility
    var description: String {
        return "\(dbn): T:\(numOfTesters), R:\(readingAvgScore), M:\(mathAvgScore) W:\(writingAvgScore) "
    }
    
    
    /// Converts an array of scores to an array of score view models
    static func toViewModels(_ schools: [SatScore]) -> [SatScoreViewModel] {
        let result:[SatScoreViewModel] = schools.map {
            SatScoreViewModel($0)
        }
        
        return result
    }
}

/// Wraps the underlying school model for use in the UI Views
class SchoolShortViewModel: Identifiable {
    var id = UUID()
    private(set) var school: SchoolShort
    
    var searchableValue: String = ""
    
    var dbn: String {
        return SchoolFormatter.string(school.dbn)
    }
    
    var name: String {
        return SchoolFormatter.string(school.school_name)
    }
    
    var addressStreet: String {
        return SchoolFormatter.string(school.primary_address_line_1)
    }
    
    var addressCSZ: String {
        return SchoolFormatter.addressCSZ(city: school.city, state: school.state_code, zip: school.zip)
    }
    
    var phoneNumber: String {
        return SchoolFormatter.string(school.phone_number)
    }
    
    var faxNumber: String {
        return SchoolFormatter.string(school.fax_number)
    }
    
    var email: String {
        return SchoolFormatter.string(school.school_email)
    }
    
    var website: String {
        return SchoolFormatter.string(school.website)
    }
    
    init(_ school: SchoolShort? = nil) {
        self.school = school == nil ? SchoolShort() : school!
        
        if school != nil {
            let arr = [
                dbn,
                name,
                addressStreet,
                addressCSZ,
                phoneNumber,
                faxNumber,
                email,
                website
            ]
            
            searchableValue = arr.joined(separator: "###").lowercased()
        }
    }
    
    /// Converts an array of schools to an array of school view models
    static func toViewModels(_ schools: [SchoolShort]) -> [SchoolShortViewModel] {
        let result:[SchoolShortViewModel] = schools.map {
            SchoolShortViewModel($0)
        }
        
        return result
    }
}

/// Wraps the underlying school model for use in the UI Views
class SchoolFullViewModel: Identifiable {
    var id = UUID()
    private(set) var school: SchoolFull
    
    var dbn: String {
        return SchoolFormatter.string(school.dbn)
    }
    
    var name: String {
        return SchoolFormatter.string(school.school_name)
    }
    
    var addressStreet: String {
        return SchoolFormatter.string(school.primary_address_line_1)
    }
    
    var addressCSZ: String {
        return SchoolFormatter.addressCSZ(city: school.city, state: school.state_code, zip: school.zip)
    }
    
    var phoneNumber: String {
        return SchoolFormatter.string(school.phone_number)
    }
    
    var faxNumber: String {
        return SchoolFormatter.string(school.fax_number)
    }
    
    var email: String {
        return SchoolFormatter.string(school.school_email)
    }
    
    var website: String {
        return SchoolFormatter.string(school.website)
    }
    
    var overview: String {
        return SchoolFormatter.string(school.overview_paragraph)
    }
    
    
    var opportunities: [String]? {
        return SchoolFormatter.valuesList(values: school.academicopportunities1, school.academicopportunities2, school.academicopportunities3, school.academicopportunities4, school.academicopportunities5)
    }
    
    
    
    var directions: [String]? {
        return SchoolFormatter.valuesList(values: school.directions1, school.directions2, school.directions3, school.directions4, school.directions5, school.directions6, school.directions7, school.directions8, school.directions9, school.directions10)
    }
    
    var extracurricularActivities: [String]? {
        return SchoolFormatter.valuesListCSV(values: school.extracurricular_activities)
    }
    
    var schoolSports: [String]? {
        return SchoolFormatter.valuesListCSV(values: school.school_sports)
    }
    
    var diplomaEndorsements: [String]? {
        return SchoolFormatter.valuesListCSV(values: school.diplomaendorsements)
    }
    
    var neighborhood: String {
        return SchoolFormatter.string(school.neighborhood)
    }
    
    var sharedSpace: Bool {
        return SchoolFormatter.boolOrDefault(school.shared_space)
    }
    
    
    var campusName: String {
        return SchoolFormatter.string(school.campus_name)
    }
    
    var hours: String {
        return "\(SchoolFormatter.string(school.start_time)) - \(SchoolFormatter.string(school.end_time))"
    }
    
    var perks: String {
        return SchoolFormatter.string(school.addtl_info1)
    }
    
    var sportsBoys: [String]? {
        return SchoolFormatter.valuesListCSV(values: school.psal_sports_boys)
    }
    
    var sportsGirls: [String]? {
        return SchoolFormatter.valuesListCSV(values: school.psal_sports_girls)
    }
    
    var sportsCoed: [String]? {
        return SchoolFormatter.valuesListCSV(values: school.psal_sports_coed)
    }
    
    // Implement if needed/time
//    var requirements: [String]? {
//        return nil
//    }
    
    var programs: [String]? {
        return SchoolFormatter.valuesList(values: school.program1, school.program2, school.program3, school.program4, school.program5, school.program6, school.program7, school.program8, school.program9, school.program10)
    }
    
    // Implement if needed/time
//    var codes: [String]? {
//        return nil
//    }
    
    var hasCoordinate: Bool {
        return latitude != nil && longitude != nil
    }
    
    
    var latitudeOrZero: Double {
        return latitude ?? 0
    }
    
    var longitudeOrZero: Double {
        return longitude ?? 0
    }
    
    var latitude: Double? {
        return SchoolFormatter.double(school.latitude)
    }
    
    var longitude: Double? {
        return SchoolFormatter.double(school.longitude)
    }
    
//    var nta: String? //"Springfield Gardens North"
//    var bourough: String?
//
//    // Pct Double strings
//    var graduation_rate: String?
//    var college_career_rate: String?
//    var attendance_rate: String? //pct
//    var pct_stu_safe: String?   //pct
//    var pct_stu_enough_variety: String?
//
//    // Grades offered
//    var finalgrades: String?
//    var total_students: String? //Int
    
    
    
    init(_ school: SchoolFull? = nil) {
        self.school = school == nil ? SchoolFull() : school!
    }
    
    /// Converts an array of schools to an array of school view models
    static func toViewModels(_ schools: [SchoolFull]) -> [SchoolFullViewModel] {
        let result:[SchoolFullViewModel] = schools.map {
            SchoolFullViewModel($0)
        }
        
        return result
    }
}

