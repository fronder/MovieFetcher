//
//  ManageFavoritesUseCaseTests.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 03/02/26.
//

import XCTest
@testable import MovieFetcher

final class ManageFavoritesUseCaseTests: XCTestCase {
    var sut: ManageFavoritesUseCase!
    var mockRepository: MockMovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        sut = ManageFavoritesUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testAddToFavorites_CallsRepository() throws {
        try sut.addToFavorites(movie: MockData.movie)
        
        XCTAssertEqual(mockRepository.addToFavoritesCallCount, 1)
    }
    
    func testGetFavorites_ReturnsRepositoryFavorites() {
        let expectedMovies = [MockData.movie]
        mockRepository.favoriteMovies = expectedMovies
        
        let favorites = sut.getFavorites()
        
        XCTAssertEqual(favorites, expectedMovies)
        XCTAssertEqual(mockRepository.getFavoriteMoviesCallCount, 1)
    }
    
    func testIsFavorite_WhenMovieIsFavorite_ReturnsTrue() {
        mockRepository.favoriteMovieIds = [1]
        
        let isFavorite = sut.isFavorite(movieId: 1)
        
        XCTAssertTrue(isFavorite)
    }
    
    func testIsFavorite_WhenMovieIsNotFavorite_ReturnsFalse() {
        mockRepository.favoriteMovieIds = []
        
        let isFavorite = sut.isFavorite(movieId: 1)
        
        XCTAssertFalse(isFavorite)
    }

    func testRemoveFromFavorites_CallsRepository() throws {
        try sut.removeFromFavorites(movieId: 1)
        
        XCTAssertEqual(mockRepository.removeFromFavoritesCallCount, 1)
    }
    
    func testToggleFavorite_WhenNotFavorite_AddsToFavorites() throws {
        mockRepository.favoriteMovieIds = []
        
        try sut.toggleFavorite(movie: MockData.movie)
        
        XCTAssertEqual(mockRepository.addToFavoritesCallCount, 1)
        XCTAssertEqual(mockRepository.removeFromFavoritesCallCount, 0)
    }
    
    func testToggleFavorite_WhenFavorite_RemovesFromFavorites() throws {
        mockRepository.favoriteMovieIds = [MockData.movie.id]
        
        try sut.toggleFavorite(movie: MockData.movie)
        
        XCTAssertEqual(mockRepository.removeFromFavoritesCallCount, 1)
        XCTAssertEqual(mockRepository.addToFavoritesCallCount, 0)
    }
}
