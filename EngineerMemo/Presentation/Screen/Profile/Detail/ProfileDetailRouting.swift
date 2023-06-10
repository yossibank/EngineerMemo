import UIKit

/// @mockable
protocol ProfileDetailRoutingInput {
    func showIconScreen(modelObject: ProfileModelObject)
    func showUpdateBasicScreen(type: ProfileUpdateBasicType)
    func showUpdateSkillScreen(type: ProfileUpdateSkillType)
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

    func showUpdateBasicScreen(type: ProfileUpdateBasicType) {
        viewController?.show(
            AppControllers.Profile.Update.Basic(type: type),
            sender: nil
        )
    }

    func showUpdateSkillScreen(type: ProfileUpdateSkillType) {
        viewController?.show(
            AppControllers.Profile.Update.Skill(type: type),
            sender: nil
        )
    }
}
