//
//  MovieRepository.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func searchMovies(query: String, page: Int) async throws -> MovieSearchResult {
        let result: MovieSearchResult = try await networkService.request(
            endpoint: .searchMovies(query: query, page: page)
        )
        
        return result
    }
}
