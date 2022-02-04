//
//  ViewDataFormattersTest.swift
//  JPMC-20220131-LeifAshley-NYCSchoolsTests
//
//  Created by Leif Ashley on 2/4/22.
//

import XCTest

class ViewDataFormattersTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBoolean() throws {
        XCTAssertTrue(ViewDataFormatter.boolOrDefault("1"))
        XCTAssertTrue(ViewDataFormatter.boolOrDefault("true"))
        XCTAssertTrue(ViewDataFormatter.boolOrDefault("YES"))
        XCTAssertFalse(ViewDataFormatter.boolOrDefault("0"))
    }
    
    func testNumbers() throws {
        XCTAssertEqual(ViewDataFormatter.double("55.1234"), 55.1234)
        XCTAssertEqual(ViewDataFormatter.int("55"), 55)
        XCTAssertEqual(ViewDataFormatter.percent("0.985"), "98.5")
        XCTAssertEqual(ViewDataFormatter.double("55.1234"), 55.1234)
    }
    
    func testValuesList() throws {
        XCTAssertEqual(ViewDataFormatter.valuesList(values: nil), nil)
        XCTAssertEqual(ViewDataFormatter.valuesList(values: "Leif", nil, "Leif", "Timmy"), ["Leif", "Timmy"])
    }
    
    func testListCSV() throws {
        XCTAssertEqual(ViewDataFormatter.valuesListCSV(values: nil), nil)
        XCTAssertEqual(ViewDataFormatter.valuesListCSV(values: "Leif Ashley, Tommy Twotone"), ["Leif Ashley", "Tommy Twotone"])
    }
}

