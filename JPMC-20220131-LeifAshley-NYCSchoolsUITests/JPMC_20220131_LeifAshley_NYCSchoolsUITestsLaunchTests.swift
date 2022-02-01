//
//  JPMC_20220131_LeifAshley_NYCSchoolsUITestsLaunchTests.swift
//  JPMC-20220131-LeifAshley-NYCSchoolsUITests
//
//  Created by Leif Ashley on 1/31/22.
//

import XCTest

class JPMC_20220131_LeifAshley_NYCSchoolsUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
