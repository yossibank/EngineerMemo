import UIKit

/// @mockable
protocol MemoListRoutingInput {
    func showCreateScreen()
    func showDetailScreen(identifier: String)
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
    func showCreateScreen() {
        viewController?.navigationController?.pushViewController(
            AppControllers.Memo.Update(type: .create),
            animated: true
        )
    }

    func showDetailScreen(identifier: String) {
        viewController?.navigationController?.pushViewController(
            AppControllers.Memo.Detail(identifier: identifier),
            animated: true
        )
    }
}
