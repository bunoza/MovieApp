//
//  MovieListCoordinator.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import Foundation
import UIKit

protocol MovieListCoordinatorDelegate {
    func openDetails(with movie: MovieItem)
}

class MovieListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    var controller: MovieListViewController?
    
    var parent: TabViewCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MovieListViewModel()
        viewModel.coordinatorDelegate = self
        controller = MovieListViewController(viewModel: viewModel)
        navigationController.pushViewController(controller!, animated: false)
    }
}

extension MovieListCoordinator: MovieListCoordinatorDelegate {
    func openDetails(with movie: MovieItem) {
        parent?.openDetails(with: movie)
    }
}
