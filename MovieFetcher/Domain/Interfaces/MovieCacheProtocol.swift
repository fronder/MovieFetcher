//
//  MovieCacheProtocol.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

protocol MovieCacheProtocol {
    func cacheMovies(_ movies: [Movie], query: String, page: Int)
    func getCachedMovies(query: String, page: Int) -> [Movie]
    func addToFavorites(movie: Movie) throws
    func isFavorite(movieId: Int) -> Bool
    func getFavoriteMovies() -> [Movie]
}
