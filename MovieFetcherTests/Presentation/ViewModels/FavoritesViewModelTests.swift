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
    
    func testRemoveFromFavorites_Success_CallsUseCaseAndReloads() {
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        sut.loadFavorites()
        
        sut.removeFromFavorites(movieId: MockData.movie.id)
        
        XCTAssertEqual(mockManageFavoritesUseCase.removeFromFavoritesCallCount, 1)
        XCTAssertEqual(mockManageFavoritesUseCase.getFavoritesCallCount, 2)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testRemoveFromFavorites_Success_UpdatesFavoritesList() {
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        sut.loadFavorites()
        XCTAssertEqual(sut.favoriteMovies.count, 2)
        
        sut.removeFromFavorites(movieId: MockData.movie.id)
        
        XCTAssertEqual(sut.favoriteMovies.count, 1)
        XCTAssertFalse(sut.favoriteMovies.contains { $0.id == MockData.movie.id })
    }
    
    func testRemoveFromFavorites_WhenError_SetsErrorMessage() {
        mockManageFavoritesUseCase.shouldThrowError = true
        
        sut.removeFromFavorites(movieId: 1)
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("Failed to remove from favorites") ?? false)
        XCTAssertEqual(mockManageFavoritesUseCase.removeFromFavoritesCallCount, 1)
    }
    
    func testRemoveFromFavorites_WhenError_DoesNotReloadFavorites() {
        mockManageFavoritesUseCase.shouldThrowError = true
        let initialCallCount = mockManageFavoritesUseCase.getFavoritesCallCount
        
        sut.removeFromFavorites(movieId: 1)
        
        XCTAssertEqual(mockManageFavoritesUseCase.getFavoritesCallCount, initialCallCount)
    }
    
    func testFavoriteMovies_IsPublished() {
        let expectation = XCTestExpectation(description: "favoriteMovies published")
        mockManageFavoritesUseCase.favoriteMovies = MockData.movies
        
        sut.$favoriteMovies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.loadFavorites()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testErrorMessage_IsPublished() {
        let expectation = XCTestExpectation(description: "errorMessage published")
        mockManageFavoritesUseCase.shouldThrowError = true
        
        sut.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.removeFromFavorites(movieId: 1)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
