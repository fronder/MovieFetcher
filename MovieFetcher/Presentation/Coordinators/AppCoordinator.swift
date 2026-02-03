//
//  AppCoordinator.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let dependencyContainer: DependencyContainer
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        showMovieSearch()
    }
    
    private func showMovieSearch() {
        let viewModel = MovieSearchViewModel(
            searchMoviesUseCase: dependencyContainer.makeSearchMoviesUseCase(),
            manageFavoritesUseCase: dependencyContainer.makeManageFavoritesUseCase()
        )
        
        let viewController = MovieSearchViewController(viewModel: viewModel)
        viewController.onMovieTap = { [weak self] movie in
            self?.showMovieDetail(movie: movie)
        }
        
        let favoritesBarButton = UIBarButtonItem(
            image: UIImage(systemName: "heart.fill"),
            style: .plain,
            target: self,
            action: #selector(showFavorites)
        )
        viewController.navigationItem.rightBarButtonItem = favoritesBarButton
                
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func showMovieDetail(movie: Movie) {
        let viewModel = MovieDetailViewModel(
            movie: movie,
            manageFavoritesUseCase: dependencyContainer.makeManageFavoritesUseCase()
        )
        
        let viewController = MovieDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    @objc private func showFavorites() {
        let viewModel = FavoritesViewModel(manageFavoritesUseCase: dependencyContainer.makeManageFavoritesUseCase())
        
        let viewController = FavoritesViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
