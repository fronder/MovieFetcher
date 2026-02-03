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
    private let dataRepository: MovieDataRepositoryProtocol
    private let cacheRepository: MovieCacheRepositoryProtocol
    
    init(dataRepository: MovieDataRepositoryProtocol, cacheRepository: MovieCacheRepositoryProtocol) {
        self.dataRepository = dataRepository
        self.cacheRepository = cacheRepository
    }
    
    func execute(query: String, page: Int) async throws -> MovieSearchResult {
        // Check cache first for faster response
        if let cachedResult = cacheRepository.getCachedMovies(query: query, page: page) {
            return cachedResult
        }
        
        // Fetch from network if not cached
        do {
            let result = try await dataRepository.searchMovies(query: query, page: page)
            cacheRepository.cacheMovies(result: result, query: query)
            return result
        } catch {
            // Try cache again as fallback on network error
            if let cachedResult = cacheRepository.getCachedMovies(query: query, page: page) {
                return cachedResult
            }
            throw error
        }
    }
}
