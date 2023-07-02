import UIKit

/// @mockable
protocol ProfileListRoutingInput {
    func showIconScreen(modelObject: ProfileModelObject)
    func showBasicUpdateScreen(modelObject: ProfileModelObject?)
    func showSkillUpdateScreen(modelObject: ProfileModelObject)
    func showProjectCreateScreen(modelObject: ProfileModelObject)
    func showProjectDetailScreen(identifier: String, modelObject: ProfileModelObject)
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
            AppControllers.Profile.Basic.Update(modelObject: modelObject),
            sender: nil
        )
    }

    func showSkillUpdateScreen(modelObject: ProfileModelObject) {
        viewController?.show(
            AppControllers.Profile.Skill.Update(modelObject: modelObject),
            sender: nil
        )
    }

    func showProjectCreateScreen(modelObject: ProfileModelObject) {
        viewController?.show(
            AppControllers.Profile.Project.Update(
                identifier: UUID().uuidString,
                modelObject: modelObject
            ),
            sender: nil
        )
    }

    func showProjectDetailScreen(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        viewController?.show(
            AppControllers.Profile.Project.Detail(
                identifier: identifier,
                modelObject: modelObject
            ),
            sender: nil
        )
    }
}
