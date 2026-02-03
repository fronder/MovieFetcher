//
//  FavoritesViewModelTests.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 03/02/26.
//

import XCTest
import Combine
@testable import MovieFetcher

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    var sut: FavoritesViewModel!
    var mockManageFavoritesUseCase: MockManageFavoritesUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockManageFavoritesUseCase = MockManageFavoritesUseCase()
        cancellables = Set<AnyCancellable>()
        
        sut = FavoritesViewModel(manageFavoritesUseCase: mockManageFavoritesUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockManageFavoritesUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadFavorites_UpdatesFavoriteMovies() {
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        
        sut.loadFavorites()
        
        XCTAssertEqual(sut.favoriteMovies.count, 2)
        XCTAssertEqual(mockManageFavoritesUseCase.getFavoritesCallCount, 1)
    }
    
    func testLoadFavorites_WhenEmpty_ReturnsEmptyArray() {
        mockManageFavoritesUseCase.favoriteMovies = []
        
        sut.loadFavorites()
        
        XCTAssertEqual(sut.favoriteMovies.count, 0)
        XCTAssertEqual(mockManageFavoritesUseCase.getFavoritesCallCount, 1)
    }
}
