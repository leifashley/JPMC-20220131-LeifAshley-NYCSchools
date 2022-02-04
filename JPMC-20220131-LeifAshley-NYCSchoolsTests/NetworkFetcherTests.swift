//
//  JPMC_20220131_LeifAshley_NYCSchoolsTests.swift
//  JPMC-20220131-LeifAshley-NYCSchoolsTests
//
//  Created by Leif Ashley on 1/31/22.
//

import XCTest
@testable import JPMC_20220131_LeifAshley_NYCSchools

class NetworkFetcherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    /// Testing valid URL String, should reliably be able to get 5 SAT scores with a dbn and name
    func testValidUrlString() throws {
        let expectation = XCTestExpectation(description: "Network data fetching")
            
        let fetcher = HttpFetcher()
        fetcher.fetchDecodable(of: [SatScore].self, urlString: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?$limit=5") { result in
            switch result.result {
            case let .success(scores):
                XCTAssertTrue(scores.count == 5)
                XCTAssertTrue(scores[0].dbn != nil)
                XCTAssertTrue(scores[0].school_name != nil)
            case let .failure(error):
                XCTFail("Error fetching data \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    /// Limit is misspelled
    func testInvalidUrlStringTest() throws {
        let expectation = XCTestExpectation(description: "Network data fetching")
            
        let fetcher = HttpFetcher()
        fetcher.fetchDecodable(of: [SatScore].self, urlString: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?$lmit=5") { result in
            switch result.result {
            case let .success(_):
                XCTFail("This should never pass, the url is invalid")
            case let .failure(_):
                break
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
