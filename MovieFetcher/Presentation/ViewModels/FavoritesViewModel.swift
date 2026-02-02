//
//  FavoritesViewModel.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 02/02/26.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []
    
    private let manageFavoritesUseCase: ManageFavoritesUseCaseProtocol
    
    init(manageFavoritesUseCase: ManageFavoritesUseCaseProtocol) {
        self.manageFavoritesUseCase = manageFavoritesUseCase
    }
    
    func loadFavorites() {
        favoriteMovies = manageFavoritesUseCase.getFavorites()
    }
}
