//
//  FavoritesViewControllerTests.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 03/02/26.
//

import XCTest
import Combine
@testable import MovieFetcher

@MainActor
final class FavoritesViewControllerTests: XCTestCase {
    var sut: FavoritesViewController!
    var mockViewModel: FavoritesViewModel!
    var mockManageFavoritesUseCase: MockManageFavoritesUseCase!
    
    override func setUp() {
        super.setUp()
        mockManageFavoritesUseCase = MockManageFavoritesUseCase()
        mockViewModel = FavoritesViewModel(manageFavoritesUseCase: mockManageFavoritesUseCase)
        sut = FavoritesViewController(viewModel: mockViewModel)
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        mockManageFavoritesUseCase = nil
        super.tearDown()
    }
    
    func testViewDidLoad_SetsUpUI() {
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "Favorites")
        XCTAssertNotNil(sut.view)
    }
    
    func testViewWillAppear_LoadsFavorites() {
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        
        XCTAssertEqual(mockManageFavoritesUseCase.getFavoritesCallCount, 1)
    }
    
    func testTableView_NumberOfRows_ReturnsCorrectCount() async {
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        sut.loadViewIfNeeded()
        mockViewModel.loadFavorites()
        
        // Wait for the Combine publisher to update
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let tableView = sut.view.subviews.compactMap { $0 as? UITableView }.first
        let numberOfRows = tableView?.numberOfRows(inSection: 0)
        
        XCTAssertEqual(numberOfRows, 2)
    }
    
    func testTableView_NumberOfRows_WhenEmpty_ReturnsZero() async {
        mockManageFavoritesUseCase.favoriteMovies = []
        sut.loadViewIfNeeded()
        mockViewModel.loadFavorites()
        
        // Wait for the Combine publisher to update
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let tableView = sut.view.subviews.compactMap { $0 as? UITableView }.first
        let numberOfRows = tableView?.numberOfRows(inSection: 0)
        
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testTableView_CellForRowAt_ConfiguresCell() async {
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        sut.loadViewIfNeeded()
        mockViewModel.loadFavorites()
        
        // Wait for the Combine publisher to update
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let tableView = sut.view.subviews.compactMap { $0 as? UITableView }.first!
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        
        XCTAssertTrue(cell is MovieTableViewCell)
    }
    
    func testOnMovieTap_WhenNotSet_DoesNotCrash() async {
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        sut.loadViewIfNeeded()
        mockViewModel.loadFavorites()
        
        // Wait for the Combine publisher to update
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let tableView = sut.view.subviews.compactMap { $0 as? UITableView }.first!
        let indexPath = IndexPath(row: 0, section: 0)
        
        XCTAssertNoThrow(tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath))
    }
    
    func testTableView_DidSelectRow_PassesCorrectMovie() async {
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        sut.loadViewIfNeeded()
        mockViewModel.loadFavorites()
        
        // Wait for the Combine publisher to update
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        var tappedMovie: Movie?
        sut.onMovieTap = { movie in
            tappedMovie = movie
        }
        
        let tableView = sut.view.subviews.compactMap { $0 as? UITableView }.first!
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        
        XCTAssertEqual(tappedMovie?.id, MockData.movies[1].id)
        XCTAssertEqual(tappedMovie?.title, MockData.movies[1].title)
    }
}

