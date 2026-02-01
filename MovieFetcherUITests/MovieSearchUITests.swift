//
//  MovieSearchUITests.swift
//  MovieFetcherUITests
//
//  Created by Hasan Abdullah on 01/02/26.
//

import XCTest

final class MovieSearchUITests: XCTestCase {
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
    
    func testNavigationTitleExists() {
        let navigationBar = app.navigationBars["Movies"]
        XCTAssertTrue(navigationBar.exists)
    }
    
    func testTableViewExists() {
        let table = app.tables.firstMatch
        XCTAssertTrue(table.exists)
    }
    
    func testSearchFunctionality() {
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.exists)
        
        searchBar.tap()
        searchBar.typeText("Inception")
        
        let table = app.tables.firstMatch
        let exists = table.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
    }
    
    func testEmptyStateDisplayed() {
        let emptyStateLabel = app.staticTexts["Search for movies"]
        XCTAssertTrue(emptyStateLabel.exists)
    }
    
    func testMovieSelectionNavigatesToDetail() {
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("Inception")
        
        let table = app.tables.firstMatch
        _ = table.waitForExistence(timeout: 5)
        
        let firstCell = table.cells.firstMatch
        if firstCell.waitForExistence(timeout: 5) {
            firstCell.tap()
            
            let backButton = app.navigationBars.buttons.firstMatch
            XCTAssertTrue(backButton.exists)
        }
    }
}
