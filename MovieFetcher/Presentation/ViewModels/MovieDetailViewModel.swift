//
//  MovieDetailViewModel.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 01/02/26.
//

import Foundation
import Combine

@MainActor
final class MovieDetailViewModel {
    @Published var movie: Movie
    @Published var isFavorite: Bool
    @Published var errorMessage: String?
    
    private let manageFavoritesUseCase: ManageFavoritesUseCaseProtocol
    
    init(movie: Movie, manageFavoritesUseCase: ManageFavoritesUseCaseProtocol) {
        self.movie = movie
        self.manageFavoritesUseCase = manageFavoritesUseCase
        self.isFavorite = manageFavoritesUseCase.isFavorite(movieId: movie.id)
    }
    
    func toggleFavorite() {
        do {
            try manageFavoritesUseCase.toggleFavorite(movie: movie)
            isFavorite = manageFavoritesUseCase.isFavorite(movieId: movie.id)
        } catch {
            errorMessage = "Failed to update favorites: \(error.localizedDescription)"
        }
    }
}
