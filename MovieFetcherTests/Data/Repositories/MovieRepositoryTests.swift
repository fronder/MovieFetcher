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
}
