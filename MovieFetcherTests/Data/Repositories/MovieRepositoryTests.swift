//
//  MovieRepositoryTests.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 02/02/26.
//

import XCTest
@testable import MovieFetcher

final class MovieRepositoryTests: XCTestCase {
    var sut: MovieRepository!
    var mockNetworkService: MockNetworkService!
    var mockCache: MockMovieCache!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockCache = MockMovieCache()
        sut = MovieRepository(networkService: mockNetworkService, cache: mockCache)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockCache = nil
        super.tearDown()
    }
    
    func testSearchMovies_Success_ReturnsResult() async throws {
        let expectedResult = MockData.searchResult
        mockNetworkService.result = expectedResult
        
        let result = try await sut.searchMovies(query: "Inception", page: 1)
        
        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }
    
    func testSearchMovies_NetworkError_ThrowsError() async {
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = NetworkError.networkError(NSError(domain: "test", code: -1))
        
        do {
            _ = try await sut.searchMovies(query: "Inception", page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(mockNetworkService.requestCallCount, 1)
        }
    }
    
    func testCacheMovies_StoresMoviesInCache() {
        let result = MockData.searchResult
        
        sut.cacheMovies(result: result, query: "Inception")
        
        XCTAssertEqual(mockCache.cacheMoviesCallCount, 1)
        XCTAssertEqual(mockCache.lastCachedQuery, "Inception")
        XCTAssertEqual(mockCache.lastCachedPage, 1)
    }
    
    func testCacheMovies_StoresTotalPagesInCache() {
        let result = MovieSearchResult(page: 1, results: MockData.movies, totalPages: 10, totalResults: 100)
        
        sut.cacheMovies(result: result, query: "Inception")
        
        XCTAssertEqual(mockCache.cacheMoviesCallCount, 1)
        XCTAssertEqual(mockCache.lastCachedTotalPages, 10)
    }
    
    func testGetCachedMovies_WithCachedData_ReturnsSearchResult() {
        let movies = MockData.movies
        mockCache.cachedMovies["Inception"] = [1: movies]
        
        let result = sut.getCachedMovies(query: "Inception", page: 1)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.results.count, 2)
        XCTAssertEqual(result?.page, 1)
        XCTAssertEqual(mockCache.getCachedMoviesCallCount, 1)
    }
    
    func testGetCachedMovies_WithoutCachedData_ReturnsNil() {
        let result = sut.getCachedMovies(query: "Inception", page: 1)
        
        XCTAssertNil(result)
        XCTAssertEqual(mockCache.getCachedMoviesCallCount, 1)
    }
    
    func testGetCachedMovies_WithEmptyCache_ReturnsNil() {
        mockCache.cachedMovies["Inception"] = [1: []]
        
        let result = sut.getCachedMovies(query: "Inception", page: 1)
        
        XCTAssertNil(result)
    }
    
    func testGetCachedMovies_WithCachedTotalPages_ReturnsCorrectTotalPages() {
        let movies = MockData.movies
        mockCache.cachedMovies["Inception"] = [1: movies]
        mockCache.cachedTotalPages["Inception"] = [1: 15]
        
        let result = sut.getCachedMovies(query: "Inception", page: 1)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.totalPages, 15)
        XCTAssertEqual(mockCache.getCachedTotalPagesCallCount, 1)
    }
    
    func testGetCachedMovies_WithoutCachedTotalPages_ReturnsFallbackValue() {
        let movies = MockData.movies
        mockCache.cachedMovies["Inception"] = [1: movies]
        
        let result = sut.getCachedMovies(query: "Inception", page: 1)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.totalPages, 1000) // Fallback value
        XCTAssertEqual(mockCache.getCachedTotalPagesCallCount, 1)
    }
    
    func testGetCachedMovies_DifferentPages_ReturnsDifferentTotalPages() {
        let movies = MockData.movies
        mockCache.cachedMovies["Inception"] = [1: movies, 2: movies]
        mockCache.cachedTotalPages["Inception"] = [1: 10, 2: 10]
        
        let result1 = sut.getCachedMovies(query: "Inception", page: 1)
        let result2 = sut.getCachedMovies(query: "Inception", page: 2)
        
        XCTAssertEqual(result1?.totalPages, 10)
        XCTAssertEqual(result2?.totalPages, 10)
        XCTAssertEqual(mockCache.getCachedTotalPagesCallCount, 2)
    }
    
    func testAddToFavorites_CallsCacheAddToFavorites() throws {
        let movie = MockData.movie
        
        try sut.addToFavorites(movie: movie)
        
        XCTAssertEqual(mockCache.addToFavoritesCallCount, 1)
    }
    
    func testRemoveFromFavorites_CallsCacheRemoveFromFavorites() throws {
        try sut.removeFromFavorites(movieId: 1)
        
        XCTAssertEqual(mockCache.removeFromFavoritesCallCount, 1)
    }
    
    func testIsFavorite_CallsCacheIsFavorite() {
        _ = sut.isFavorite(movieId: 1)
        
        XCTAssertEqual(mockCache.isFavoriteCallCount, 1)
    }
    
    func testGetFavoriteMovies_CallsCacheGetFavoriteMovies() {
        _ = sut.getFavoriteMovies()
        
        XCTAssertEqual(mockCache.getFavoriteMoviesCallCount, 1)
    }
}
