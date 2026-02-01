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
        
    init(movie: Movie) {
        self.movie = movie
    }
}
