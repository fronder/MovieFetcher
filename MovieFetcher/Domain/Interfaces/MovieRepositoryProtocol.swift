//
//  MovieRepositoryProtocol.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

protocol MovieRepositoryProtocol {
    func searchMovies(query: String, page: Int) async throws -> MovieSearchResult
}
