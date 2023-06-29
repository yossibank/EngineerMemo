import UIKit

/// @mockable
protocol ProjectDetailRoutingInput {
    func showUpdateScreen(identifier: String, modelObject: ProfileModelObject)
}

// MARK: - properties & init

final class ProjectDetailRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension ProjectDetailRouting: ProjectDetailRoutingInput {
    func showUpdateScreen(
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
