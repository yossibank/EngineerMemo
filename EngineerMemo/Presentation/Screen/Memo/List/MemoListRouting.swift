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
        viewController?.show(
            AppControllers.Memo.Update(modelObject: nil),
            sender: nil
        )
    }

    func showDetailScreen(identifier: String) {
        viewController?.show(
            AppControllers.Memo.Detail(identifier: identifier),
            sender: nil
        )
    }
}
