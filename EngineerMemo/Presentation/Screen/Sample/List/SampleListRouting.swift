import UIKit

/// @mockable
protocol SampleListRoutingInput {
    func showAddScreen()
    func showDetailScreen(_ modelObject: SampleModelObject)
}

// MARK: - properties & init

final class SampleListRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension SampleListRouting: SampleListRoutingInput {
    func showAddScreen() {
        viewController?.navigationController?.pushViewController(
            AppControllers.Sample.Add(),
            animated: true
        )
    }

    func showDetailScreen(_ modelObject: SampleModelObject) {
        viewController?.navigationController?.pushViewController(
            AppControllers.Sample.Detail(modelObject),
            animated: true
        )
    }
}
