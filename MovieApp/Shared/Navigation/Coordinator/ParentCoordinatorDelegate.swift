// Urheberrechtshinweis: Diese Software ist urheberrechtlich geschützt. Das Urheberrecht liegt bei
// Research Industrial Systems Engineering (RISE) Forschungs-, Entwicklungs- und Großprojektberatung GmbH,
// soweit nicht im Folgenden näher gekennzeichnet.

import Foundation

protocol ParentCoordinatorDelegate: Coordinator { }

extension ParentCoordinatorDelegate where Self: Coordinator {
    func childDidFinish(_ coordinator: Coordinator) {
        for (index, coord) in childCoordinators.enumerated() {
            if coord === coordinator {
                childCoordinators.remove(at: index)
                print("Coordinator \(coordinator) removed.")
            }
        }
    }
}
