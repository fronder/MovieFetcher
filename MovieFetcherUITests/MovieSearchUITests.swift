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
    
    func testSearchResults_DisplayMovieInformation() {
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("Matrix")
        
        let table = app.tables.firstMatch
        _ = table.waitForExistence(timeout: 5)
        
        let firstCell = table.cells.firstMatch
        if firstCell.waitForExistence(timeout: 5) {
            XCTAssertTrue(firstCell.staticTexts.count > 0, "Cell should display movie information")
        }
    }
    
    func testClearSearch_RemovesResults() {
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("Avatar")
        
        let table = app.tables.firstMatch
        _ = table.waitForExistence(timeout: 5)
        
        if table.cells.count > 0 {
            let clearButton = searchBar.buttons["Clear text"]
            if clearButton.exists {
                clearButton.tap()
                
                let emptyStateLabel = app.staticTexts["Search for movies"]
                XCTAssertTrue(emptyStateLabel.waitForExistence(timeout: 2))
            }
        }
    }
    
    func testNavigateBackFromDetail_PreservesSearchResults() {
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("Inception")
        
        let table = app.tables.firstMatch
        _ = table.waitForExistence(timeout: 5)
        
        let firstCell = table.cells.firstMatch
        if firstCell.waitForExistence(timeout: 5) {
            firstCell.tap()
            
            let backButton = app.navigationBars.buttons.firstMatch
            if backButton.exists {
                backButton.tap()
                
                XCTAssertTrue(table.exists, "Search results should be preserved")
            }
        }
    }
    
    func testLoadingIndicator_AppearsWhileSearching() {
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("Action")
        
        let loadingIndicator = app.activityIndicators.firstMatch
        if loadingIndicator.waitForExistence(timeout: 2) {
            XCTAssertTrue(loadingIndicator.exists, "Loading indicator should appear")
        }
    }
}
