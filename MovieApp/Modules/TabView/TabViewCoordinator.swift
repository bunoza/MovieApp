// Urheberrechtshinweis: Diese Software ist urheberrechtlich geschützt. Das Urheberrecht liegt bei
// Research Industrial Systems Engineering (RISE) Forschungs-, Entwicklungs- und Großprojektberatung GmbH,
// soweit nicht im Folgenden näher gekennzeichnet.

import Foundation
import UIKit

protocol TabViewCoordinatorDelegate: ParentCoordinatorDelegate {
    func openDetails(with movie: MovieItem)
}

class TabViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var parent: ParentCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        var viewControllers: [UIViewController] = []
        viewControllers.append(createMovieListController())
        let tab = TabViewController()
        print(viewControllers.count)
        tab.setViewControllers(viewControllers: viewControllers)
        navigationController.pushViewController(tab, animated: true)
    }
    
    
    func createMovieListController() -> UIViewController {
        let nav = UINavigationController()
        let coordinator = MovieListCoordinator(navigationController: nav)
        coordinator.parent = self
        childCoordinators.append(coordinator)
        coordinator.start()
        return coordinator.controller!
    }
}

extension TabViewCoordinator: TabViewCoordinatorDelegate {
    func childDidFinish(_: Coordinator) {
        return
    }
    
    func openDetails(with movie: MovieItem) {
        let coordinator = MovieDetailsCoordintator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.startDetails(with: movie)
    }
}
