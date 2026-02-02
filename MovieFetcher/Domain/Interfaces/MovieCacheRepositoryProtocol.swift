//
//  MovieCacheRepositoryProtocol.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 02/02/26.
//

import Foundation

protocol MovieCacheRepositoryProtocol {
    func getCachedMovies(query: String, page: Int) -> MovieSearchResult?
    func cacheMovies(result: MovieSearchResult, query: String)
}
