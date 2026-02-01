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
}
