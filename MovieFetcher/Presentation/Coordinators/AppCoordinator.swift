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
        let viewModel = MovieSearchViewModel(searchMoviesUseCase: dependencyContainer.makeSearchMoviesUseCase())
        
        let viewController = MovieSearchViewController(viewModel: viewModel)
                
        navigationController.pushViewController(viewController, animated: false)
    }
}
