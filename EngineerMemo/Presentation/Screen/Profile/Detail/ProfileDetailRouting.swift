import UIKit

/// @mockable
protocol ProfileDetailRoutingInput {
    func showUpdateScreen()
}

// MARK: - stored properties & init

final class ProfileDetailRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension ProfileDetailRouting: ProfileDetailRoutingInput {
    func showUpdateScreen() {
        viewController?.navigationController?.pushViewController(
            AppControllers.Profile.Update(type: .setting),
            animated: true
        )
    }
}
