//
//  MovieRepository.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let cache: MovieCacheProtocol
    
    init(networkService: NetworkServiceProtocol, cache: MovieCacheProtocol) {
        self.networkService = networkService
        self.cache = cache
    }
    
    func searchMovies(query: String, page: Int) async throws -> MovieSearchResult {
        let result: MovieSearchResult = try await networkService.request(
            endpoint: .searchMovies(query: query, page: page)
        )
        
        cacheMovies(result: result, query: query)
        return result
    }
    
    func cacheMovies(result: MovieSearchResult, query: String) {
        cache.cacheMovies(result.results, query: query, page: result.page)
    }
    
    func getCachedMovies(query: String, page: Int) -> MovieSearchResult? {
        let movies = cache.getCachedMovies(query: query, page: page)
        guard !movies.isEmpty else { return nil }
        
        return MovieSearchResult(
            page: page,
            results: movies,
            totalPages: page,
            totalResults: movies.count
        )
    }
}
