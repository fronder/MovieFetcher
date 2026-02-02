//
//  FavoritesRepositoryProtocol.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 02/02/26.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func addToFavorites(movie: Movie) throws
    func isFavorite(movieId: Int) -> Bool
    func getFavoriteMovies() -> [Movie]
    func removeFromFavorites(movieId: Int) throws
}
