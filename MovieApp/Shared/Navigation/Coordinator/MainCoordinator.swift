//
//  MainCoordinator.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 12.02.2022..
//

import Foundation
import UIKit

class MainCoordinator : Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(window: UIWindow?) {
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func start() {
        let coordinator = TabViewCoordinator(navigationController: navigationController)
        coordinator.parent = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    //    static func openDetails(of movie: MovieItem) {
    //        let detailsViewController = MovieDetailsViewController(viewModel: MovieDetailsViewModel(movie: movie))
    //        detailsViewController.modalPresentationStyle = .overCurrentContext
    //        self.navigationController.pushViewController(detailsViewController, animated: true)
    //    }
}

extension MainCoordinator: ParentCoordinatorDelegate {
    func childDidFinish(_: Coordinator) {
        return
    }
}
