//
//  SearchMoviesUseCaseTests.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 02/02/26.
//

import XCTest
@testable import MovieFetcher

final class SearchMoviesUseCaseTests: XCTestCase {
    var sut: SearchMoviesUseCase!
    var mockRepository: MockMovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        sut = SearchMoviesUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_WhenCacheExists_ReturnsCachedResult() async throws {
        let expectedResult = MovieSearchResult(
            page: 1,
            results: [MockData.movie],
            totalPages: 1,
            totalResults: 1
        )
        mockRepository.cachedResult = expectedResult
        
        let result = try await sut.execute(query: "test", page: 1)
        
        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(mockRepository.getCachedMoviesCallCount, 1)
        XCTAssertEqual(mockRepository.searchMoviesCallCount, 0)
    }
    
    func testExecute_WhenNoCacheAndResponseSucceeds_ReturnsResponseResult() async throws {
        let expectedResult = MovieSearchResult(
            page: 1,
            results: [MockData.movie],
            totalPages: 1,
            totalResults: 1
        )
        mockRepository.searchResult = expectedResult
        
        let result = try await sut.execute(query: "test", page: 1)
        
        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(mockRepository.searchMoviesCallCount, 1)
        XCTAssertEqual(mockRepository.cacheMoviesCallCount, 1)
    }
    
    func testExecute_WhenResponseFailsAndCacheExists_ReturnsCachedResult() async throws {
        let expectedResult = MovieSearchResult(
            page: 1,
            results: [MockData.movie],
            totalPages: 1,
            totalResults: 1
        )
        mockRepository.cachedResult = expectedResult
        mockRepository.shouldThrowError = true
        
        let result = try await sut.execute(query: "test", page: 1)
        
        XCTAssertEqual(result, expectedResult)
    }
}
