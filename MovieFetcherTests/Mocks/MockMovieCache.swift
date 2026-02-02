//
//  MockMovieCache.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 03/02/26.
//

import Foundation

final class MockMovieCache: MovieCacheProtocol {
    var cacheMoviesCallCount = 0
    
    func cacheMovies(_ movies: [Movie], query: String, page: Int) {
        cacheMoviesCallCount += 1
    }
    
    func getCachedMovies(query: String, page: Int) -> [Movie] {
        return []
    }
    
    func addToFavorites(movie: Movie) throws {
        
    }
    
    func isFavorite(movieId: Int) -> Bool {
        return true
    }
    
    func getFavoriteMovies() -> [Movie] {
        return []
    }
}
