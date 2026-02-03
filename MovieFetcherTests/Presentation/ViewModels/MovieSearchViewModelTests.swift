//
//  MovieSearchViewModelTests.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 01/02/26.
//

import XCTest
import Combine
@testable import MovieFetcher

final class MovieSearchViewModelTests: XCTestCase {
    var sut: MovieSearchViewModel!
    var mockSearchUseCase: MockSearchMoviesUseCase!
    var mockFavoritesUseCase: MockManageFavoritesUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockSearchUseCase = MockSearchMoviesUseCase()
        mockFavoritesUseCase = MockManageFavoritesUseCase()
        cancellables = Set<AnyCancellable>()
        
        sut = MovieSearchViewModel(
            searchMoviesUseCase: mockSearchUseCase,
            manageFavoritesUseCase: mockFavoritesUseCase
        )
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSearchMovies_WhenQueryIsValid_UpdatesMovies() async {
        mockSearchUseCase.result = MockData.searchResult
        
        await sut.searchMovies(query: "test", resetResults: true)
        
        XCTAssertEqual(sut.movies.count, 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testSearchMovies_WhenQueryIsEmpty_DoesNotSearch() async {
        await sut.searchMovies(query: "", resetResults: true)
        
        XCTAssertEqual(mockSearchUseCase.executeCallCount, 0)
    }
    
    func testSearchMovies_WhenError_SetsErrorMessage() async {
        mockSearchUseCase.shouldThrowError = true
        
        await sut.searchMovies(query: "test", resetResults: true)
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoadMoreMovies_WhenHasMorePages_LoadsNextPage() async {
        mockSearchUseCase.result = MockData.searchResult
        
        await sut.searchMovies(query: "test", resetResults: true)
        sut.hasMorePages = true
        await sut.loadMoreMovies()
        
        XCTAssertEqual(mockSearchUseCase.executeCallCount, 2)
    }
    
    func testSearchMovies_WithDuplicates_FiltersDuplicateMovies() async {
        // First page with 2 movies
        let movie1 = Movie(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: nil, backdropPath: nil, releaseDate: "2024-01-01", voteAverage: 7.5, voteCount: 100, popularity: 50.0)
        let movie2 = Movie(id: 2, title: "Movie 2", overview: "Overview 2", posterPath: nil, backdropPath: nil, releaseDate: "2024-01-02", voteAverage: 8.0, voteCount: 200, popularity: 60.0)
        
        mockSearchUseCase.result = MovieSearchResult(page: 1, results: [movie1, movie2], totalPages: 2, totalResults: 4)
        
        await sut.searchMovies(query: "test", resetResults: true)
        XCTAssertEqual(sut.movies.count, 2)
        
        // Second page with 1 duplicate and 1 new movie
        let movie3 = Movie(id: 3, title: "Movie 3", overview: "Overview 3", posterPath: nil, backdropPath: nil, releaseDate: "2024-01-03", voteAverage: 7.0, voteCount: 150, popularity: 55.0)
        mockSearchUseCase.result = MovieSearchResult(page: 2, results: [movie2, movie3], totalPages: 2, totalResults: 4) // movie2 is duplicate
        
        await sut.loadMoreMovies()
        
        // Should only have 3 unique movies (movie2 duplicate filtered out)
        XCTAssertEqual(sut.movies.count, 3)
        XCTAssertTrue(sut.movies.contains(where: { $0.id == 1 }))
        XCTAssertTrue(sut.movies.contains(where: { $0.id == 2 }))
        XCTAssertTrue(sut.movies.contains(where: { $0.id == 3 }))
    }
    
    func testSearchMovies_ResetResults_ClearsMoviesAndIds() async {
        // First search
        mockSearchUseCase.result = MockData.searchResult
        await sut.searchMovies(query: "test1", resetResults: true)
        XCTAssertEqual(sut.movies.count, 2)
        
        // Second search with reset - should clear previous movies
        let newMovie = Movie(id: 999, title: "New Movie", overview: "New", posterPath: nil, backdropPath: nil, releaseDate: "2024-01-01", voteAverage: 7.0, voteCount: 100, popularity: 50.0)
        mockSearchUseCase.result = MovieSearchResult(page: 1, results: [newMovie], totalPages: 1, totalResults: 1)
        
        await sut.searchMovies(query: "test2", resetResults: true)
        
        XCTAssertEqual(sut.movies.count, 1)
        XCTAssertEqual(sut.movies.first?.id, 999)
    }
    
    func testSearchMovies_PaginationWithAllDuplicates_DoesNotAddDuplicates() async {
        let movie1 = Movie(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: nil, backdropPath: nil, releaseDate: "2024-01-01", voteAverage: 7.5, voteCount: 100, popularity: 50.0)
        let movie2 = Movie(id: 2, title: "Movie 2", overview: "Overview 2", posterPath: nil, backdropPath: nil, releaseDate: "2024-01-02", voteAverage: 8.0, voteCount: 200, popularity: 60.0)
        
        mockSearchUseCase.result = MovieSearchResult(page: 1, results: [movie1, movie2], totalPages: 2, totalResults: 4)
        await sut.searchMovies(query: "test", resetResults: true)
        XCTAssertEqual(sut.movies.count, 2)
        
        // Second page returns all duplicates
        mockSearchUseCase.result = MovieSearchResult(page: 2, results: [movie1, movie2], totalPages: 2, totalResults: 4)
        await sut.loadMoreMovies()
        
        // Should still have only 2 movies (no duplicates added)
        XCTAssertEqual(sut.movies.count, 2)
    }

}
