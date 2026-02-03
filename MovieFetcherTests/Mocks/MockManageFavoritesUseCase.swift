//
//  MockManageFavoritesUseCase.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 02/02/26.
//

import Foundation
@testable import MovieFetcher

final class MockManageFavoritesUseCase: ManageFavoritesUseCaseProtocol {
    var favoriteMovies: [Movie] = []
    var shouldThrowError = false
    var removeFromFavoritesCallCount = 0
    var getFavoritesCallCount = 0
    var addToFavoritesCallCount = 0
    
    func isFavorite(movieId: Int) -> Bool {
        return favoriteMovies.contains { $0.id == movieId }
    }
    
    func toggleFavorite(movie: Movie) throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        }
    }
    
    func getFavorites() -> [Movie] {
        getFavoritesCallCount += 1
        return favoriteMovies
    }
    
    func removeFromFavorites(movieId: Int) throws {
        removeFromFavoritesCallCount += 1
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to remove favorite"])
        }
        favoriteMovies.removeAll { $0.id == movieId }
    }
    
    func addToFavorites(movie: Movie) throws {
        addToFavoritesCallCount += 1
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        }
        favoriteMovies.append(movie)
    }
}
