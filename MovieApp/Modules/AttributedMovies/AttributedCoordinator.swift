//
//  FavoriteCoordinator.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 23.02.2022..
//

import Foundation
import UIKit

protocol AttributedCoordinatorDelegate {
    func openDetails(with movie: MovieItem)
}

class AttributedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    var controller: AttributedMoviesViewController?
    
    var parent: TabViewCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    }
    
    func startFavorites() {
        let viewModel = AttributedMoviesViewModel(tag: "favorites")
        viewModel.coordinatorDelegate = self
        controller = AttributedMoviesViewController(viewModel: viewModel)
        navigationController.pushViewController(controller!, animated: false)
    }
    
    func startWatched() {
        let viewModel = AttributedMoviesViewModel(tag: "watched")
        viewModel.coordinatorDelegate = self
        controller = AttributedMoviesViewController(viewModel: viewModel)
        navigationController.pushViewController(controller!, animated: false)
    }
}

extension AttributedCoordinator: AttributedCoordinatorDelegate {
    func openDetails(with movie: MovieItem) {
        parent?.openDetails(with: movie)
    }
}
