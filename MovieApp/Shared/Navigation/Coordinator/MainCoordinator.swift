//
//  MainCoordinator.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 12.02.2022..
//

import Foundation
import UIKit

class MainCoordinator : Coordinator {
    var childCoordinator = [Coordinator]()
    static var navigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        MainCoordinator.navigationController = navigationController
    }
    
    func start() {
        let controller = TabViewController()
        MainCoordinator.navigationController.pushViewController(controller, animated: false)
    }

    static func openDetails(of movie: MovieItem) {
        let detailsViewController = MovieDetailsViewController(viewModel: MovieDetailsViewModel(movie: movie))
        detailsViewController.modalPresentationStyle = .overCurrentContext
        self.navigationController.pushViewController(detailsViewController, animated: true)
    }
}
