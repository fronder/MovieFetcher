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
    var addToFavoritesCallCount = 0
    var removeFromFavoritesCallCount = 0
    var isFavoriteCallCount = 0
    var getFavoriteMoviesCallCount = 0
    
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
        addToFavoritesCallCount += 1
    }
    
    func removeFromFavorites(movieId: Int) throws {
        removeFromFavoritesCallCount += 1
    }
    
    func isFavorite(movieId: Int) -> Bool {
        isFavoriteCallCount += 1
        return true
    }
    
    func getFavoriteMovies() -> [Movie] {
        getFavoriteMoviesCallCount += 1
        return []
    }
}
