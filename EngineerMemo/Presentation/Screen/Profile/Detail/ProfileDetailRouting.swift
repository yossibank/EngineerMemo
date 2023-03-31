import UIKit

/// @mockable
protocol ProfileDetailRoutingInput {
    func showIconScreen(modelObject: ProfileModelObject)
    func showUpdateScreen(type: ProfileUpdateType)
}

// MARK: - properties & init

final class ProfileDetailRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension ProfileDetailRouting: ProfileDetailRoutingInput {
    func showIconScreen(modelObject: ProfileModelObject) {
        viewController?.navigationController?.pushViewController(
            AppControllers.Profile.Icon(modelObject: modelObject),
            animated: true
        )
    }

    func showUpdateScreen(type: ProfileUpdateType) {
        viewController?.navigationController?.pushViewController(
            AppControllers.Profile.Update(type: type),
            animated: true
        )
    }
}
