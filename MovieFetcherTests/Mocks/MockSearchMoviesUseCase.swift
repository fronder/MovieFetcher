//
//  MockSearchMoviesUseCase.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 01/02/26.
//

import Foundation
@testable import MovieFetcher

final class MockSearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    var result: MovieSearchResult?
    var shouldThrowError = false
    var executeCallCount = 0
    
    func execute(query: String, page: Int) async throws -> MovieSearchResult {
        executeCallCount += 1
        
        if shouldThrowError {
            throw NetworkError.networkError(NSError(domain: "test", code: -1))
        }
        
        guard let result = result else {
            throw NetworkError.noData
        }
        
        return result
    }
}
