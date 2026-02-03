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
}
