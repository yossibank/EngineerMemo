import UIKit

/// @mockable
protocol ProfileListRoutingInput {
    func showIconScreen(modelObject: ProfileModelObject)
    func showBasicUpdateScreen(modelObject: ProfileModelObject?)
    func showSkillUpdateScreen(modelObject: ProfileModelObject)
    func showProjectUpdateScreen(identifier: String, modelObject: ProfileModelObject)
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

    func showBasicUpdateScreen(modelObject: ProfileModelObject?) {
        viewController?.show(
            AppControllers.Profile.Information.Basic.Update(modelObject: modelObject),
            sender: nil
        )
    }

    func showSkillUpdateScreen(modelObject: ProfileModelObject) {
        viewController?.show(
            AppControllers.Profile.Information.Skill.Update(modelObject: modelObject),
            sender: nil
        )
    }

    func showProjectUpdateScreen(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        viewController?.show(
            AppControllers.Profile.Information.Project.Update(
                identifier: identifier,
                modelObject: modelObject
            ),
            sender: nil
        )
    }
}
