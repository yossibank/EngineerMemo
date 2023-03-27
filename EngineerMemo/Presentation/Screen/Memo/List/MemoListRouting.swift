import UIKit

/// @mockable
protocol MemoListRoutingInput {
    func showDetailScreen(modelObject: MemoModelObject)
}

// MARK: - properties & init

final class MemoListRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension MemoListRouting: MemoListRoutingInput {
    func showDetailScreen(modelObject: MemoModelObject) {
        viewController?.navigationController?.pushViewController(
            AppControllers.Memo.Detail(modelObject: modelObject),
            animated: true
        )
    }
}
