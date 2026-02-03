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
        sut = SearchMoviesUseCase(dataRepository: mockRepository, cacheRepository: mockRepository)
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
    
    func testExecute_WhenResponseFailsAndNoCacheExists_ThrowsError() async {
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await sut.execute(query: "test", page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testExecute_WhenCacheExists_ReturnsCorrectTotalPages() async throws {
        let expectedResult = MovieSearchResult(
            page: 1,
            results: [MockData.movie],
            totalPages: 15,
            totalResults: 150
        )
        mockRepository.cachedResult = expectedResult
        
        let result = try await sut.execute(query: "test", page: 1)
        
        XCTAssertEqual(result.totalPages, 15)
        XCTAssertEqual(mockRepository.getCachedMoviesCallCount, 1)
    }
    
    func testExecute_WhenRequestSucceeds_CachesTotalPages() async throws {
        let expectedResult = MovieSearchResult(
            page: 1,
            results: [MockData.movie],
            totalPages: 20,
            totalResults: 200
        )
        mockRepository.searchResult = expectedResult
        
        let result = try await sut.execute(query: "test", page: 1)
        
        XCTAssertEqual(result.totalPages, 20)
        XCTAssertEqual(mockRepository.cacheMoviesCallCount, 1)
    }
    
    func testExecute_MultiplePagesWithDifferentTotalPages_CachesCorrectly() async throws {
        // First page
        let page1Result = MovieSearchResult(
            page: 1,
            results: [MockData.movie],
            totalPages: 10,
            totalResults: 100
        )
        mockRepository.searchResult = page1Result
        
        let result1 = try await sut.execute(query: "test", page: 1)
        XCTAssertEqual(result1.totalPages, 10)
        
        // Second page - totalPages should remain consistent
        let page2Result = MovieSearchResult(
            page: 2,
            results: [MockData.movie],
            totalPages: 10,
            totalResults: 100
        )
        mockRepository.searchResult = page2Result
        
        let result2 = try await sut.execute(query: "test", page: 2)
        XCTAssertEqual(result2.totalPages, 10)
        XCTAssertEqual(mockRepository.cacheMoviesCallCount, 2)
    }
    
    func testExecute_RequestFailsWithCachedTotalPages_ReturnsCachedTotalPages() async throws {
        let cachedResult = MovieSearchResult(
            page: 1,
            results: [MockData.movie],
            totalPages: 25,
            totalResults: 250
        )
        mockRepository.cachedResult = cachedResult
        mockRepository.shouldThrowError = true
        
        let result = try await sut.execute(query: "test", page: 1)
        
        XCTAssertEqual(result.totalPages, 25)
    }
}
