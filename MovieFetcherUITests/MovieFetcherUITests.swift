//
//  MovieFetcherUITests.swift
//  MovieFetcherUITests
//
//  Created by Hasan Abdullah on 30/01/26.
//

import XCTest

final class MovieFetcherUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSearchBarExists() {
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.exists)
    }
}
