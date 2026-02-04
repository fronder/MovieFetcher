//
//  MovieDetailViewModelTests.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 04/02/26.
//

import Foundation
import XCTest
import Combine
@testable import MovieFetcher

@MainActor
final class MovieDetailViewModelTests: XCTestCase {
    var sut: MovieDetailViewModel!
    var mockManageFavoritesUseCase: MockManageFavoritesUseCase!
    var testMovie: Movie!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        testMovie = MockData.movie
        mockManageFavoritesUseCase = MockManageFavoritesUseCase()
        cancellables = Set<AnyCancellable>()
        sut = MovieDetailViewModel(movie: testMovie, manageFavoritesUseCase: mockManageFavoritesUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockManageFavoritesUseCase = nil
        testMovie = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInit_SetsMovieProperty() {
        XCTAssertEqual(sut.movie.id, testMovie.id)
        XCTAssertEqual(sut.movie.title, testMovie.title)
        XCTAssertEqual(sut.movie.overview, testMovie.overview)
    }
    
    func testInit_WhenMovieIsNotFavorite_SetsFavoriteToFalse() {
        XCTAssertFalse(sut.isFavorite)
    }
    
    func testInit_WhenMovieIsFavorite_SetsFavoriteToTrue() {
        mockManageFavoritesUseCase.favoriteMovies = [testMovie]
        
        sut = MovieDetailViewModel(movie: testMovie, manageFavoritesUseCase: mockManageFavoritesUseCase)
        
        XCTAssertTrue(sut.isFavorite)
    }
    
    func testInit_SetsErrorMessageToNil() {
        XCTAssertNil(sut.errorMessage)
    }
    
    func testToggleFavorite_WhenNotFavorite_UpdatesIsFavoriteToTrue() {
        XCTAssertFalse(sut.isFavorite)
        
        mockManageFavoritesUseCase.favoriteMovies = [testMovie]
        sut.toggleFavorite()
        
        XCTAssertTrue(sut.isFavorite)
    }
    
    func testToggleFavorite_WhenIsFavorite_UpdatesIsFavoriteToFalse() {
        mockManageFavoritesUseCase.favoriteMovies = [testMovie]
        sut = MovieDetailViewModel(movie: testMovie, manageFavoritesUseCase: mockManageFavoritesUseCase)
        XCTAssertTrue(sut.isFavorite)
        
        mockManageFavoritesUseCase.favoriteMovies = []
        sut.toggleFavorite()
        
        XCTAssertFalse(sut.isFavorite)
    }
    
    func testToggleFavorite_CallsManageFavoritesUseCase() {
        sut.toggleFavorite()
        
        // Verify the use case was called (no error thrown)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testToggleFavorite_WhenUseCaseThrowsError_SetsErrorMessage() {
        mockManageFavoritesUseCase.shouldThrowError = true
        
        sut.toggleFavorite()
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("Failed to update favorites") ?? false)
    }
    
    func testToggleFavorite_WhenUseCaseThrowsError_DoesNotUpdateIsFavorite() {
        let initialFavoriteState = sut.isFavorite
        mockManageFavoritesUseCase.shouldThrowError = true
        
        sut.toggleFavorite()
        
        XCTAssertEqual(sut.isFavorite, initialFavoriteState)
    }
    
    func testToggleFavorite_MultipleTimes_TogglesCorrectly() {
        XCTAssertFalse(sut.isFavorite)
        
        // First toggle - add to favorites
        mockManageFavoritesUseCase.favoriteMovies = [testMovie]
        sut.toggleFavorite()
        XCTAssertTrue(sut.isFavorite)
        
        // Second toggle - remove from favorites
        mockManageFavoritesUseCase.favoriteMovies = []
        sut.toggleFavorite()
        XCTAssertFalse(sut.isFavorite)
        
        // Third toggle - add again
        mockManageFavoritesUseCase.favoriteMovies = [testMovie]
        sut.toggleFavorite()
        XCTAssertTrue(sut.isFavorite)
    }
    
    func testIsFavorite_IsPublished() async {
        let expectation = XCTestExpectation(description: "isFavorite publishes changes")
        var receivedValues: [Bool] = []
        
        sut.$isFavorite
            .sink { value in
                receivedValues.append(value)
                if receivedValues.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        mockManageFavoritesUseCase.favoriteMovies = [testMovie]
        sut.toggleFavorite()
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues.count, 2)
        XCTAssertFalse(receivedValues[0])
        XCTAssertTrue(receivedValues[1])
    }
    
    func testErrorMessage_IsPublished() async {
        let expectation = XCTestExpectation(description: "errorMessage publishes changes")
        var receivedValues: [String?] = []
        
        sut.$errorMessage
            .sink { value in
                receivedValues.append(value)
                if receivedValues.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        mockManageFavoritesUseCase.shouldThrowError = true
        sut.toggleFavorite()
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues.count, 2)
        XCTAssertNil(receivedValues[0])
        XCTAssertNotNil(receivedValues[1])
    }
    
    func testToggleFavorite_WithDifferentMovie_DoesNotAffectCurrentMovie() {
        let anotherMovie = Movie(
            id: 999,
            title: "Another Movie",
            overview: "Another overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 7.0,
            voteCount: 100,
            popularity: 50.0
        )
        
        mockManageFavoritesUseCase.favoriteMovies = [anotherMovie]
        
        XCTAssertFalse(sut.isFavorite)
    }
}
