//
//  MovieDetailsCoordinator.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import Foundation
import UIKit

class MovieDetailsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var parent: TabViewCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        return
    }
    
    func startDetails(with movie: MovieItem) {
        let viewModel = MovieDetailsViewModel(movie: movie)
        let vc = MovieDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
}
