//
//  MockMovieRepository.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 02/02/26.
//

import Foundation
@testable import MovieFetcher

final class MockMovieRepository: MovieRepositoryProtocol {
    var searchResult: MovieSearchResult?
    var cachedResult: MovieSearchResult?
    var shouldThrowError = false
    var favoriteMovies: [Movie] = []
    var favoriteMovieIds: [Int] = []
    
    var searchMoviesCallCount = 0
    var getCachedMoviesCallCount = 0
    var cacheMoviesCallCount = 0
    var addToFavoritesCallCount = 0
    var getFavoriteMoviesCallCount = 0
    var isFavoriteCallCount = 0
    var removeFromFavoritesCallCount = 0
    
    func searchMovies(query: String, page: Int) async throws -> MovieSearchResult {
        searchMoviesCallCount += 1
        
        if shouldThrowError {
            throw NetworkError.networkError(NSError(domain: "test", code: -1))
        }
        
        guard let result = searchResult else {
            throw NetworkError.noData
        }
        
        return result
    }
    
    func getCachedMovies(query: String, page: Int) -> MovieSearchResult? {
        getCachedMoviesCallCount += 1
        return cachedResult
    }
    
    func cacheMovies(result: MovieSearchResult, query: String) {
        cacheMoviesCallCount += 1
    }
    
    func addToFavorites(movie: Movie) throws {
        addToFavoritesCallCount += 1
        favoriteMovies.append(movie)
        favoriteMovieIds.append(movie.id)
    }
    
    func removeFromFavorites(movieId: Int) throws {
        removeFromFavoritesCallCount += 1
        favoriteMovies.removeAll { $0.id == movieId }
        favoriteMovieIds.removeAll { $0 == movieId }
    }
    
    func getFavoriteMovies() -> [Movie] {
        getFavoriteMoviesCallCount += 1
        return favoriteMovies
    }
    
    func isFavorite(movieId: Int) -> Bool {
        isFavoriteCallCount += 1
        return favoriteMovieIds.contains(movieId)
    }
}
