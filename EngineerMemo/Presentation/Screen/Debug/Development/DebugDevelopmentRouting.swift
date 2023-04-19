#if DEBUG
    import UIKit

    /// @mockable
    protocol DebugDevelopmentRoutingInput {
        func showDebugAPIScreen()
        func showDebugCoreDataScreen(action: DebugCoreDataAction)
    }

    // MARK: - properties & init

    final class DebugDevelopmentRouting {
        private weak var viewController: UIViewController?

        init(viewController: UIViewController) {
            self.viewController = viewController
        }
    }

    // MARK: - protocol

    extension DebugDevelopmentRouting: DebugDevelopmentRoutingInput {
        func showDebugAPIScreen() {
            viewController?.show(
                AppControllers.Debug.API(),
                sender: nil
            )
        }

        func showDebugCoreDataScreen(action: DebugCoreDataAction) {
            let vc: UIViewController

            switch action {
            case .list:
                vc = AppControllers.Debug.CoreData.List()

            case .create:
                vc = AppControllers.Debug.CoreData.Create()

            case .update:
                vc = AppControllers.Debug.CoreData.Update()
            }

            viewController?.show(
                vc,
                sender: nil
            )
        }
    }
#endif
