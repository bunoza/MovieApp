// Urheberrechtshinweis: Diese Software ist urheberrechtlich geschützt. Das Urheberrecht liegt bei
// Research Industrial Systems Engineering (RISE) Forschungs-, Entwicklungs- und Großprojektberatung GmbH,
// soweit nicht im Folgenden näher gekennzeichnet.

import Foundation
import UIKit

class MovieDetailsCoordintator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
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
