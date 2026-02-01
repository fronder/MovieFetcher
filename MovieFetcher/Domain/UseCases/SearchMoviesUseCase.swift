//
//  SearchMoviesUseCase.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

protocol SearchMoviesUseCaseProtocol {
    func execute(query: String, page: Int) async throws -> MovieSearchResult
}

final class SearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int) async throws -> MovieSearchResult {
        if let cachedResult = repository.getCachedMovies(query: query, page: page) {
            return cachedResult
        }
        
        do {
            let result = try await repository.searchMovies(query: query, page: page)
            return result
        } catch {
            if let cachedResult = repository.getCachedMovies(query: query, page: page) {
                return cachedResult
            }
            throw error
        }
    }
}
