//
//  ManageFavoritesUseCase.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 02/02/26.
//

import Foundation

protocol ManageFavoritesUseCaseProtocol {
    func isFavorite(movieId: Int) -> Bool
    func toggleFavorite(movie: Movie) throws
    func getFavorites() -> [Movie]
    func removeFromFavorites(movieId: Int) throws
}

final class ManageFavoritesUseCase: ManageFavoritesUseCaseProtocol {
    private let repository: FavoritesRepositoryProtocol
    
    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }
    
    func isFavorite(movieId: Int) -> Bool {
        return repository.isFavorite(movieId: movieId)
    }
    
    func toggleFavorite(movie: Movie) throws {
        if isFavorite(movieId: movie.id) {
            try removeFromFavorites(movieId: movie.id)
        } else {
            try addToFavorites(movie: movie)
        }
    }
    
    func getFavorites() -> [Movie] {
        return repository.getFavoriteMovies()
    }
    
    func addToFavorites(movie: Movie) throws {
        try repository.addToFavorites(movie: movie)
    }
    
    func removeFromFavorites(movieId: Int) throws {
        try repository.removeFromFavorites(movieId: movieId)
    }
}
