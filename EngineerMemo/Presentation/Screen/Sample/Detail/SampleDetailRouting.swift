import UIKit

/// @mockable
protocol SampleDetailRoutingInput {
    func showEditScreen(modelObject: SampleModelObject)
}

// MARK: - properties & init

final class SampleDetailRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension SampleDetailRouting: SampleDetailRoutingInput {
    func showEditScreen(modelObject: SampleModelObject) {
        viewController?.present(
            UINavigationController(
                rootViewController: AppControllers.Sample.Edit(modelObject)
            ),
            animated: true
        )
    }
}
