//
//  DataModels.swift
//  CommandLineRunner
//
//  Created by Leif Ashley on 2/1/22.
//

import Foundation


// TODO: class or struct?
struct SatScore: Decodable {
    
    var dbn: String?
    var school_name: String? //TODO: probably don't need this, remove for memory saving
    var num_of_sat_test_takers: String?
    var sat_critical_reading_avg_score: String?
    var sat_math_avg_score: String?
    var sat_writing_avg_score: String?
}

class SchoolShort: Decodable, CustomStringConvertible {
    var dbn: String?
    var school_name: String?
    var primary_address_line_1: String?
    
    var city: String?
    var state_code: String?
    var zip: String?
    var phone_number: String?
    var fax_number: String?
    var school_email: String?
    var website: String?
    
    var description: String {
        return "SchoolShort: \(dbn.valueOrDefault) '\(school_name.valueOrDefault)'"
    }
}

class SchoolFull: Decodable, CustomStringConvertible {
    var dbn: String? // school ID
    var school_name: String?
    var primary_address_line_1: String?
    
    var city: String?
    var state_code: String?
    var zip: String?
    var phone_number: String?
    var fax_number: String?
    var school_email: String?
    var website: String?
    
    var overview_paragraph: String?
    
    var latitude: String?
    var longitude: String?
    var nta: String? //"Springfield Gardens North"
    var bourough: String?
    
    // Pct Double strings
    var graduation_rate: String?
    var college_career_rate: String?
    var attendance_rate: String? //pct
    var pct_stu_safe: String?   //pct
    var pct_stu_enough_variety: String?
    
    // Grades offered
    var finalgrades: String?
    var total_students: String? //Int
    
    // Bullet point list of perks of the school
    var academicopportunities1: String?
    var academicopportunities2: String?
    var academicopportunities3: String?
    var academicopportunities4: String?
    var academicopportunities5: String?
    
    var extracurricular_activities: String?
    var school_sports: String?
    
    //English Language Learners
    var ell_programs: String?
    var language_classes: String? //"French, Spanish"
    
    //Such as the following, comma separated: "AP English, AP Environmental Science, AP US History"
    var advancedplacement_courses: String?
    
    // address mixed with lat/long.
    var location: String?
    
    // Subway and Bus details, might be related to lines and bus routes
    var subway: String?
    var bus: String?
    
    // Directions on things about school, not to it
    var directions1: String?
    var directions2: String?
    var directions3: String?
    var directions4: String?
    var directions5: String?
    var directions6: String?
    var directions7: String?
    var directions8: String?
    var directions9: String?
    var directions10: String?
    
    
    
    // CSV
    var diplomaendorsements: String?
    
    // ? - same as address?
    var neighborhood: String?
    
    // ?
    var shared_space: String?
    
    var campus_name: String?
    
    // Hours
    var start_time: String?
    var end_time: String?
    
    // Perks
    var addtl_info1: String?
    var psal_sports_boys: String?
    var psal_sports_girls: String?
    var psal_sports_coed: String?
    
    // Special Programs?
    var program1: String?
    var program2: String?
    var program3: String?
    var program4: String?
    var program5: String?
    var program6: String?
    var program7: String?
    var program8: String?
    var program9: String?
    var program10: String?
    
    // *** No idea, unused
//    var school_10th_seats: String?
//    var building_code: String?
//    var grades2018: String?
//    var pct_stu_enough_variety: String?
//    var girls: String? // seems like just nil or 1
//    var boys: String? // seems like just nil or 1
//    var pbat: String? // seems like just nil or 1
//    var international: String? // seems like just nil or 1
//    var specialized: String? // seems like just nil or 1
//    var transfer: String? // seems like just nil or 1
//    var ptech: String? // seems like just nil or 1
//    var earlycollege: String? // seems like just nil or 1
//    var geoeligibility: String? // seems like just nil or 1
//    var school_accessibility_description: String? // seems like just nil or 1
//    var community_board: String?
//    var council_district: String?
//    var census_tract: String?
//    var bin: String?
//    var bbl: String?
    
    
    
    // ? Program description
//    var prgdesc1: String?
//    var prgdesc2: String?
//    var prgdesc3: String?
//    var prgdesc4: String?
//    var prgdesc5: String?
//    var prgdesc6: String?
//    var prgdesc7: String?
//    var prgdesc8: String?
//    var prgdesc9: String?
//    var prgdesc10: String?
    
    // ? Entrance Requirements
//    var requirement1_1: String?
//    var requirement1_2: String?
//    var requirement1_3: String?
//    var requirement1_4: String?
//    var requirement1_5: String?
//    var requirement1_6: String?
//    var requirement1_7: String?
//    var requirement1_8: String?
//    var requirement1_9: String?
//    var requirement1_10: String?
//    var requirement2_1: String?
//    var requirement2_2: String?
//    var requirement2_3: String?
//    var requirement2_4: String?
//    var requirement2_5: String?
//    var requirement2_6: String?
//    var requirement2_7: String?
//    var requirement2_8: String?
//    var requirement2_9: String?
//    var requirement2_10: String?
//    var requirement3_1: String?
//    var requirement3_2: String?
//    var requirement3_3: String?
//    var requirement3_4: String?
//    var requirement3_5: String?
//    var requirement3_6: String?
//    var requirement3_7: String?
//    var requirement3_8: String?
//    var requirement3_9: String?
//    var requirement3_10: String?
//    var requirement4_1: String?
//    var requirement4_2: String?
//    var requirement4_3: String?
//    var requirement4_4: String?
//    var requirement4_5: String?
//    var requirement4_6: String?
//    var requirement4_7: String?
//    var requirement4_8: String?
//    var requirement4_9: String?
//    var requirement4_10: String?
//    var requirement5_1: String?
//    var requirement5_2: String?
//    var requirement5_3: String?
//    var requirement5_4: String?
//    var requirement5_5: String?
//    var requirement5_6: String?
//    var requirement5_7: String?
//    var requirement5_8: String?
//    var requirement5_9: String?
//    var requirement5_10: String?
//    var requirement6_1: String?
//    var requirement6_2: String?
//    var requirement6_3: String?
//    var requirement6_4: String?
//    var requirement6_5: String?
//    var requirement6_6: String?
//    var requirement6_7: String?
//    var requirement6_8: String?
//    var requirement6_9: String?
//    var requirement6_10: String?
//    var requirement7_1: String?
//    var requirement7_2: String?
//    var requirement7_3: String?
//    var requirement7_4: String?
//    var requirement7_5: String?
//    var requirement7_6: String?
//    var requirement7_7: String?
//    var requirement7_8: String?
//    var requirement7_9: String?
//    var requirement7_10: String?
//    var requirement8_1: String?
//    var requirement8_2: String?
//    var requirement8_3: String?
//    var requirement8_4: String?
//    var requirement8_5: String?
//    var requirement8_6: String?
//    var requirement8_7: String?
//    var requirement8_8: String?
//    var requirement8_9: String?
//    var requirement8_10: String?
//    var requirement9_1: String?
//    var requirement9_2: String?
//    var requirement9_3: String?
//    var requirement9_4: String?
//    var requirement9_5: String?
//    var requirement9_6: String?
//    var requirement9_7: String?
//    var requirement9_8: String?
//    var requirement9_9: String?
//    var requirement9_10: String?
//    var requirement10_1: String?
//    var requirement10_2: String?
//    var requirement10_3: String?
//    var requirement10_4: String?
//    var requirement10_5: String?
//    var requirement10_6: String?
//    var requirement10_7: String?
//    var requirement10_8: String?
//    var requirement10_9: String?
//    var requirement10_10: String?
//    var requirement11_1: String?
//    var requirement11_2: String?
//    var requirement11_3: String?
//    var requirement11_4: String?
//    var requirement11_5: String?
//    var requirement11_6: String?
//    var requirement11_7: String?
//    var requirement11_8: String?
//    var requirement11_9: String?
//    var requirement11_10: String?
//    var requirement12_1: String?
//    var requirement12_2: String?
//    var requirement12_3: String?
//    var requirement12_4: String?
//    var requirement12_5: String?
//    var requirement12_6: String?
//    var requirement12_7: String?
//    var requirement12_8: String?
//    var requirement12_9: String?
//    var requirement12_10: String?
    
    // Not sure, looks like garbage data in json
//    var offer_rate1: String?
//    var offer_rate2: String?
//    var offer_rate3: String?
//    var offer_rate4: String?
//    var offer_rate5: String?
//    var offer_rate6: String?
//    var offer_rate7: String?
//    var offer_rate8: String?
//    var offer_rate9: String?
//    var offer_rate10: String?

    
    // No idea
//    var code1: String?
//    var code2: String?
//    var code3: String?
//    var code4: String?
//    var code5: String?
//    var code6: String?
//    var code7: String?
//    var code8: String?
//    var code9: String?
//    var code10: String?
    
    // ? list of fun things?
    // "interest1": "Humanities & Interdisciplinary"
    // "interest1": "Performing Arts/Visual Art & Design"
//    var interest1: String?
//    var interest2: String?
//    var interest3: String?
//    var interest4: String?
//    var interest5: String?
//    var interest6: String?
//    var interest7: String?
//    var interest8: String?
//    var interest9: String?
//    var interest10: String?
    
    // ? no idea - "method1": "Limited Unscreened"
//    var method1: String?
//    var method2: String?
//    var method3: String?
//    var method4: String?
//    var method5: String?
//    var method6: String?
//    var method7: String?
//    var method8: String?
//    var method9: String?
//    var method10: String?
    
    // Unclear on the rest
//    var seats9ge1: String?
//    var seats9ge2: String?
//    var seats9ge3: String?
//    var seats9ge4: String?
//    var seats9ge5: String?
//    var seats9ge6: String?
//    var seats9ge7: String?
//    var seats9ge8: String?
//    var seats9ge9: String?
//    var seats9ge10: String?
//
//    var grade9gefilledflag1: String?
//    var grade9gefilledflag2: String?
//    var grade9gefilledflag3: String?
//    var grade9gefilledflag4: String?
//    var grade9gefilledflag5: String?
//    var grade9gefilledflag6: String?
//    var grade9gefilledflag7: String?
//    var grade9gefilledflag8: String?
//    var grade9gefilledflag9: String?
//    var grade9gefilledflag10: String?
//
//    var grade9geapplicants1: String?
//    var grade9geapplicants2: String?
//    var grade9geapplicants3: String?
//    var grade9geapplicants4: String?
//    var grade9geapplicants5: String?
//    var grade9geapplicants6: String?
//    var grade9geapplicants7: String?
//    var grade9geapplicants8: String?
//    var grade9geapplicants9: String?
//    var grade9geapplicants10: String?
//
//    var seats9swd1: String?
//    var seats9swd2: String?
//    var seats9swd3: String?
//    var seats9swd4: String?
//    var seats9swd5: String?
//    var seats9swd6: String?
//    var seats9swd7: String?
//    var seats9swd8: String?
//    var seats9swd9: String?
//    var seats9swd10: String?
//
//    var grade9swdfilledflag1: String?
//    var grade9swdfilledflag2: String?
//    var grade9swdfilledflag3: String?
//    var grade9swdfilledflag4: String?
//    var grade9swdfilledflag5: String?
//    var grade9swdfilledflag6: String?
//    var grade9swdfilledflag7: String?
//    var grade9swdfilledflag8: String?
//    var grade9swdfilledflag9: String?
//    var grade9swdfilledflag10: String?
//
//    var grade9swdapplicants1: String?
//    var grade9swdapplicants2: String?
//    var grade9swdapplicants3: String?
//    var grade9swdapplicants4: String?
//    var grade9swdapplicants5: String?
//    var grade9swdapplicants6: String?
//    var grade9swdapplicants7: String?
//    var grade9swdapplicants8: String?
//    var grade9swdapplicants9: String?
//    var grade9swdapplicants10: String?
//
//    var seats1specialized: String?
//    var seats2specialized: String?
//    var seats3specialized: String?
//    var seats4specialized: String?
//    var seats5specialized: String?
//    var seats6specialized: String?
//
//    var applicants1specialized: String?
//    var applicants2specialized: String?
//    var applicants3specialized: String?
//    var applicants4specialized: String?
//    var applicants5specialized: String?
//    var applicants6specialized: String?
//    var appperseat1specialized: String?
//    var appperseat2specialized: String?
//    var appperseat3specialized: String?
//    var appperseat4specialized: String?
//    var appperseat5specialized: String?
//    var appperseat6specialized: String?
//
//    var seats101: String?
//    var seats102: String?
//    var seats103: String?
//    var seats104: String?
//    var seats105: String?
//    var seats106: String?
//    var seats107: String?
//    var seats108: String?
//    var seats109: String?
//    var seats1010: String?
//
//    var admissionspriority11: String?
//    var admissionspriority12: String?
//    var admissionspriority13: String?
//    var admissionspriority14: String?
//    var admissionspriority15: String?
//    var admissionspriority16: String?
//    var admissionspriority17: String?
//    var admissionspriority18: String?
//    var admissionspriority19: String?
//    var admissionspriority110: String?
//    var admissionspriority21: String?
//    var admissionspriority22: String?
//    var admissionspriority23: String?
//    var admissionspriority24: String?
//    var admissionspriority25: String?
//    var admissionspriority26: String?
//    var admissionspriority27: String?
//    var admissionspriority28: String?
//    var admissionspriority29: String?
//    var admissionspriority210: String?
//    var admissionspriority31: String?
//    var admissionspriority32: String?
//    var admissionspriority33: String?
//    var admissionspriority34: String?
//    var admissionspriority35: String?
//    var admissionspriority36: String?
//    var admissionspriority37: String?
//    var admissionspriority38: String?
//    var admissionspriority39: String?
//    var admissionspriority310: String?
//    var admissionspriority41: String?
//    var admissionspriority42: String?
//    var admissionspriority43: String?
//    var admissionspriority44: String?
//    var admissionspriority45: String?
//    var admissionspriority46: String?
//    var admissionspriority47: String?
//    var admissionspriority48: String?
//    var admissionspriority49: String?
//    var admissionspriority410: String?
//    var admissionspriority51: String?
//    var admissionspriority52: String?
//    var admissionspriority53: String?
//    var admissionspriority54: String?
//    var admissionspriority55: String?
//    var admissionspriority56: String?
//    var admissionspriority57: String?
//    var admissionspriority58: String?
//    var admissionspriority59: String?
//    var admissionspriority510: String?
//    var admissionspriority61: String?
//    var admissionspriority62: String?
//    var admissionspriority63: String?
//    var admissionspriority64: String?
//    var admissionspriority65: String?
//    var admissionspriority66: String?
//    var admissionspriority67: String?
//    var admissionspriority68: String?
//    var admissionspriority69: String?
//    var admissionspriority610: String?
//    var admissionspriority71: String?
//    var admissionspriority72: String?
//    var admissionspriority73: String?
//    var admissionspriority74: String?
//    var admissionspriority75: String?
//    var admissionspriority76: String?
//    var admissionspriority77: String?
//    var admissionspriority78: String?
//    var admissionspriority79: String?
//    var admissionspriority710: String?
//
//    var eligibility1: String?
//    var eligibility2: String?
//    var eligibility3: String?
//    var eligibility4: String?
//    var eligibility5: String?
//    var eligibility6: String?
//    var eligibility7: String?
//    var eligibility8: String?
//    var eligibility9: String?
//    var eligibility10: String?
//
//    var auditioninformation1: String?
//    var auditioninformation2: String?
//    var auditioninformation3: String?
//    var auditioninformation4: String?
//    var auditioninformation5: String?
//    var auditioninformation6: String?
//    var auditioninformation7: String?
//    var auditioninformation8: String?
//    var auditioninformation9: String?
//    var auditioninformation10: String?
//
//    var common_audition1: String?
//    var common_audition2: String?
//    var common_audition3: String?
//    var common_audition4: String?
//    var common_audition5: String?
//    var common_audition6: String?
//    var common_audition7: String?
//    var common_audition8: String?
//    var common_audition9: String?
//    var common_audition10: String?
//
//    var grade9geapplicantsperseat1: String?
//    var grade9geapplicantsperseat2: String?
//    var grade9geapplicantsperseat3: String?
//    var grade9geapplicantsperseat4: String?
//    var grade9geapplicantsperseat5: String?
//    var grade9geapplicantsperseat6: String?
//    var grade9geapplicantsperseat7: String?
//    var grade9geapplicantsperseat8: String?
//    var grade9geapplicantsperseat9: String?
//    var grade9geapplicantsperseat10: String?
//    var grade9swdapplicantsperseat1: String?
//    var grade9swdapplicantsperseat2: String?
//    var grade9swdapplicantsperseat3: String?
//    var grade9swdapplicantsperseat4: String?
//    var grade9swdapp: String?
    
    var description: String {
        return "SchoolFull: \(dbn.valueOrDefault) '\(school_name.valueOrDefault)'"
    }
}
