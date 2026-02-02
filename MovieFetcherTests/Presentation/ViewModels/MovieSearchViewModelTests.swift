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
        cancellables = Set<AnyCancellable>()
        
        sut = MovieSearchViewModel(
            searchMoviesUseCase: mockSearchUseCase,
            manageFavoritesUseCase: mockFavoritesUseCase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockSearchUseCase = nil
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

}
