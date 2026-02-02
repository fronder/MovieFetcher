//
//  DependencyContainer.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

final class DependencyContainer {
    private let networkService: NetworkServiceProtocol
    private let movieRepository: MovieRepository
    private let cache: MovieCacheProtocol
    
    init() {
        self.networkService = NetworkService()
        self.cache = CoreDataMovieCache(coreDataManager: CoreDataManager.shared)
        self.movieRepository = MovieRepository(
            networkService: networkService,
            cache: cache
        )
    }
    
    func makeSearchMoviesUseCase() -> SearchMoviesUseCaseProtocol {
        return SearchMoviesUseCase(dataRepository: movieRepository, cacheRepository: movieRepository)
    }
}
