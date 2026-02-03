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
}
