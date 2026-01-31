//
//  MovieSearchViewModel.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 30/01/26.
//

import Foundation
import Combine

final class MovieSearchViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    
    init(searchMoviesUseCase: SearchMoviesUseCaseProtocol) {
        self.searchMoviesUseCase = searchMoviesUseCase
    }
}
