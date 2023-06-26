import UIKit

/// @mockable
protocol ProjectDetailRoutingInput {}

// MARK: - properties & init

final class ProjectDetailRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension ProjectDetailRouting: ProjectDetailRoutingInput {}
