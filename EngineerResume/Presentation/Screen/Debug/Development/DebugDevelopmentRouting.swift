#if DEBUG
    import UIKit

    /// @mockable
    protocol DebugDevelopmentRoutingInput {
        func showDebugCoreDataScreen(item: DebugCoreDataItem)
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
        func showDebugCoreDataScreen(item: DebugCoreDataItem) {
            let vc: UIViewController

            switch item {
            case .list:
                vc = AppControllers.Debug.CoreData.List()

            case .create:
                vc = AppControllers.Debug.CoreData.Create()

            case .update:
                vc = .init()

            case .delete:
                vc = .init()
            }

            viewController?.navigationController?.pushViewController(
                vc,
                animated: true
            )
        }
    }
#endif
