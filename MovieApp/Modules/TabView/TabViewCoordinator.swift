//
//  TabViewCoordinator.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import Foundation
import UIKit

protocol TabViewCoordinatorDelegate: ParentCoordinatorDelegate {
    func openDetails(with movie: MovieItem)
}

class TabViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var controller: TabViewController?
    var parent: ParentCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        var viewControllers: [UIViewController] = []
        viewControllers.append(createFavoriteController())
        viewControllers.append(createMovieListController())
        viewControllers.append(createWatchedController())
        let controller = TabViewController()
        print(viewControllers.count)
        controller.setViewControllers(viewControllers: viewControllers)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func createMovieListController() -> UIViewController {
        let coordinator = MovieListCoordinator(navigationController: navigationController)
        coordinator.parent = self
        childCoordinators.append(coordinator)
        coordinator.start()
        return coordinator.controller!
    }
    
    func createFavoriteController() -> UIViewController {
        let coordinator = AttributedCoordinator(navigationController: navigationController)
        coordinator.parent = self
        childCoordinators.append(coordinator)
        coordinator.startFavorites()
        return coordinator.controller!
    }
    
    func createWatchedController() -> UIViewController {
        let coordinator = AttributedCoordinator(navigationController: navigationController)
        coordinator.parent = self
        childCoordinators.append(coordinator)
        coordinator.startWatched()
        return coordinator.controller!
    }
}

extension TabViewCoordinator: TabViewCoordinatorDelegate {
    func childDidFinish(_: Coordinator) {
        return
    }
    
    func openDetails(with movie: MovieItem) {
        let coordinator = MovieDetailsCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.startDetails(with: movie)
    }
}
