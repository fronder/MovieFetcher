//
//  DependencyContainer.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

final class DependencyContainer {
    private let networkService: NetworkServiceProtocol
    private let movieRepository: MovieRepositoryProtocol
    
    init() {
        self.networkService = NetworkService()
        self.movieRepository = MovieRepository(networkService: networkService)
    }
    
    func makeSearchMoviesUseCase() -> SearchMoviesUseCaseProtocol {
        return SearchMoviesUseCase(repository: movieRepository)
    }
}
