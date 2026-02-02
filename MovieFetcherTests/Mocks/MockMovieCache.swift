//
//  MockMovieCache.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 03/02/26.
//

import Foundation

final class MockMovieCache: MovieCacheProtocol {
    var cachedMovies: [String: [Int: [Movie]]] = [:]
    var lastCachedQuery: String?
    var lastCachedPage: Int?
    var cacheMoviesCallCount = 0
    var getCachedMoviesCallCount = 0
    
    func cacheMovies(_ movies: [Movie], query: String, page: Int) {
        cacheMoviesCallCount += 1
        lastCachedQuery = query
        lastCachedPage = page
        
        if cachedMovies[query] == nil {
            cachedMovies[query] = [:]
        }
        cachedMovies[query]?[page] = movies
    }
    
    func getCachedMovies(query: String, page: Int) -> [Movie] {
        getCachedMoviesCallCount += 1
        
        return cachedMovies[query]?[page] ?? []
    }
    
    func addToFavorites(movie: Movie) throws {
        
    }
    
    func removeFromFavorites(movieId: Int) throws {
        
    }
    
    func isFavorite(movieId: Int) -> Bool {
        return true
    }
    
    func getFavoriteMovies() -> [Movie] {
        return []
    }
}
