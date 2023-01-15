#if DEBUG
    import UIKit

    /// @mockable
    protocol DebugDevelopmentRoutingInput {
        func showDebugCoreDataScreen()
    }

    // MARK: - stored properties & init

    final class DebugDevelopmentRouting {
        private weak var viewController: UIViewController?

        init(viewController: UIViewController) {
            self.viewController = viewController
        }
    }

    // MARK: - protocol

    extension DebugDevelopmentRouting: DebugDevelopmentRoutingInput {
        func showDebugCoreDataScreen() {
            viewController?.navigationController?.pushViewController(
                AppControllers.Debug.CoreData(),
                animated: true
            )
        }
    }
#endif
