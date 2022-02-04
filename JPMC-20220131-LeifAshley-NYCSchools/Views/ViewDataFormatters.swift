//
//  Formatter.swift
//  JPMC-20220131-LeifAshley-NYCSchools
//
//  Created by Leif Ashley on 2/2/22.
//

import Foundation


class ViewDataFormatter {
    static var defaultString = "-"
    
    private init() {}
    
    // Generic
    static func string(_ value: String?, defaultValue: String = defaultString) -> String {
        return value == nil ? defaultValue : value!
    }
    
    static func int(_ value: String?) -> Int? {
        var numValue: Int? = nil
        
        if let value = value, let i = Int(value) {
            numValue = i
        }
        
        return numValue
    }
    
    static func double(_ value: String?) -> Double? {
        var numValue: Double? = nil
        
        if let value = value, let i = Double(value) {
            numValue = i
        }
        
        return numValue
    }
    
    static func percent(_ value: String?, precision: Int = 1, defaultValue: String = defaultString) -> String {
        var result = defaultValue
        
        if let value = value, var dValue = double(value) {
            dValue *= 100
            result = String(format: "%.\(precision)f%", dValue)
        }
        
//        NumberFormatter.percentSymbol
        
        return result
    }
    
    static func boolOrDefault(_ value: String?, defaultValue: String = defaultString) -> Bool {
        let strValue = string(value).lowercased()
        
        return strValue == "yes" || strValue == "true" || strValue == "1"
    }
    
    
    /// Should build a string array while ignoring nil values and removing duplicates
    /// - Parameter values: String Veridic
    /// - Returns: String Array
    static func valuesList(values: String?...) -> [String]? {
        var result = [String]()
        
        for value in values {
            if let v = value, !(result.contains(v)) {
                result.append(v)
            }
        }
        
        return result.count == 0 ? nil : result
    }
    
    static func valuesListCSV(values: String?) -> [String]? {
        var result = [String]()
        
        if let v = values {
            let arr = v.components(separatedBy: ",")
            
            for item in arr {
                result.append(item.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        
        return result.count == 0 ? nil : result
    }
    
    // ViewModels Printer support
    static func printArr(_ title: String, array: [String]?) {
        if let arr = array {
            for (index, value) in arr.enumerated() {
                log.toConsole("-- \(title)\(index+1): \(value)")
            }
        } else {
            log.toConsole("-- ERR!! \(title) is empty")
        }
    }
    
    static func printHeader(_ title: String) {
        log.toConsole("------------ \(title) --------------")
    }
    
    static func printFooter() {
        log.toConsole("---------------------------------------")
    }
}

class SatFormatter: ViewDataFormatter {
    static func printSatScores(_ schools: [SatScore]) {
        let arr = [SatScoreViewModel]()
        printSatScores(arr)
    }
    
    static func printSatScores(_ scores: [SatScoreViewModel]) {
        for score in scores {
            printSatScore(score)
        }
        
        log.toConsole("TOTAL: \(scores.count)")
    }
    
    static func printSatScore(_ satScore: SatScoreViewModel) {
        printHeader("printSatScore")
        
        log.toConsole("-- dbn: \(satScore.dbn)")
        log.toConsole("-- schoolName: \(satScore.schoolName)")
        log.toConsole("-- numOfTesters: \(satScore.numOfTesters)")
        log.toConsole("-- readingAvgScore: \(satScore.readingAvgScore)")
        log.toConsole("-- mathAvgScore: \(satScore.mathAvgScore)")
        log.toConsole("-- writingAvgScore: \(satScore.writingAvgScore)")
        
        printFooter()
    }
}

class SchoolFormatter: ViewDataFormatter {
    static func addressCSZ(city : String?, state : String?, zip : String?) -> String {
        return "\(string(city)), \(string(state)) \(string(zip))"
    }
   
    static func printSchools(_ schools: [SchoolShort]) {
        printSchools(SchoolShortViewModel.toViewModels(schools))
    }
    
    static func printSchools(_ schools: [SchoolShortViewModel]) {
        for score in schools {
            printSchool(score)
        }
        
        log.toConsole("TOTAL: \(schools.count)")
    }
    
    static func printSchools(_ schools: [SchoolFull]) {
        printSchools(SchoolFullViewModel.toViewModels(schools))
    }
    
    static func printSchools(_ schools: [SchoolFullViewModel]) {
        for score in schools {
            printSchool(score)
        }
        
        log.toConsole("TOTAL: \(schools.count)")
    }
    
    static func printSchool(_ school: SchoolShortViewModel) {
        printHeader("printSchool Short")
        log.toConsole("-- dbn: \(school.dbn)")
        log.toConsole("-- name: \(school.name)")
        log.toConsole("-- address: \(school.addressStreet)")
        log.toConsole("-- csz: \(school.addressCSZ)")
        log.toConsole("-- phone: \(school.phoneNumber)")
        log.toConsole("-- fax: \(school.faxNumber)")
        log.toConsole("-- email: \(school.email)")
        log.toConsole("-- website: \(school.website)")
        printFooter()
    }
    
    static func printSchool(_ school: SchoolFullViewModel) {
        printHeader("printSchool Full")
        log.toConsole("-- dbn: \(school.dbn)")
        log.toConsole("-- name: \(school.name)")
        log.toConsole("-- address: \(school.addressStreet)")
        log.toConsole("-- csz: \(school.addressCSZ)")
        log.toConsole("-- phone: \(school.phoneNumber)")
        log.toConsole("-- fax: \(school.faxNumber)")
        log.toConsole("-- email: \(school.email)")
        log.toConsole("-- website: \(school.website)")
        log.toConsole("")
        
        printArr("Directions", array: school.directions)
        printArr("Opportunties", array: school.opportunities)
        
        printArr("extracurricularActivities", array: school.extracurricularActivities)
        printArr("schoolSports", array: school.schoolSports)
        log.toConsole("")
        
        printArr("diplomaEndorsements", array: school.diplomaEndorsements)
        log.toConsole("-- neighborhood: \(school.neighborhood)")
        log.toConsole("-- sharedSpace: \(school.sharedSpace)")
        
        log.toConsole("-- campusName: \(school.campusName)")
        log.toConsole("-- hours: \(school.hours)")
        
        printArr("sportsBoys", array: school.sportsBoys)
        printArr("sportsGirls", array: school.sportsGirls)
        printArr("sportsCoed", array: school.sportsCoed)
        printArr("programs", array: school.programs)
        
        var s = ""
        s = school.latitude == nil ? "-" : String(school.latitude!)
        log.toConsole("-- latitude: \(s)")
        
        s = school.longitude == nil ? "-" : String(school.longitude!)
        log.toConsole("-- longitude: \(s)")
        printFooter()
    }
}
