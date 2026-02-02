//
//  MockManageFavoritesUseCase.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 02/02/26.
//

import Foundation
@testable import MovieFetcher

final class MockManageFavoritesUseCase: ManageFavoritesUseCaseProtocol {
    func isFavorite(movieId: Int) -> Bool {
        return true
    }
    
    func toggleFavorite(movie: Movie) throws {
        
    }
    
    func getFavorites() -> [Movie] {
        return []
    }
    
    func removeFromFavorites(movieId: Int) throws {
        
    }
}
