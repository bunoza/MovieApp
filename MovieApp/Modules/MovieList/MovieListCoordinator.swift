// Urheberrechtshinweis: Diese Software ist urheberrechtlich geschützt. Das Urheberrecht liegt bei
// Research Industrial Systems Engineering (RISE) Forschungs-, Entwicklungs- und Großprojektberatung GmbH,
// soweit nicht im Folgenden näher gekennzeichnet.

import Foundation
import UIKit

protocol MovieListCoordinatorDelegate {
    func openDetails(with movie: MovieItem)
}

class MovieListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    var controller: MovieListViewController?
    
    var parent: (ParentCoordinatorDelegate & TabViewCoordinatorDelegate)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MovieListViewModel()
        viewModel.coordinatorDelegate = self
        controller = MovieListViewController(viewModel: viewModel)
    }
}

extension MovieListCoordinator: MovieListCoordinatorDelegate {
    func openDetails(with movie: MovieItem) {
        parent?.openDetails(with: movie)
    }
}
