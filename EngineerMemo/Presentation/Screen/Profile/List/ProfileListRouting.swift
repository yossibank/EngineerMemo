import UIKit

/// @mockable
protocol ProfileListRoutingInput {
    func showIconScreen(modelObject: ProfileModelObject)
    func showUpdateBasicScreen(modelObject: ProfileModelObject?)
    func showUpdateSkillScreen(modelObject: ProfileModelObject)
    func showUpdateProjectScreen(identifier: String, modelObject: ProfileModelObject)
}

// MARK: - properties & init

final class ProfileListRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension ProfileListRouting: ProfileListRoutingInput {
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

    func showUpdateProjectScreen(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        viewController?.show(
            AppControllers.Profile.Update.Project(
                identifier: identifier,
                modelObject: modelObject
            ),
            sender: nil
        )
    }
}
