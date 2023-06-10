import UIKit

/// @mockable
protocol ProfileDetailRoutingInput {
    func showIconScreen(modelObject: ProfileModelObject)
    func showUpdateBasicScreen(modelObject: ProfileModelObject?)
    func showUpdateSkillScreen(modelObject: ProfileModelObject)
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
        viewController?.show(
            AppControllers.Profile.Icon(modelObject: modelObject),
            sender: nil
        )
    }

    func showUpdateBasicScreen(modelObject: ProfileModelObject?) {
        viewController?.show(
            AppControllers.Profile.Update.Basic(modelObject: modelObject),
            sender: nil
        )
    }

    func showUpdateSkillScreen(modelObject: ProfileModelObject) {
        viewController?.show(
            AppControllers.Profile.Update.Skill(modelObject: modelObject),
            sender: nil
        )
    }
}
