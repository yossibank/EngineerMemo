import UIKit

/// @mockable
protocol MemoDetailRoutingInput {
    func showUpdateScreen(modelObject: MemoModelObject)
}

// MARK: - properties & init

final class MemoDetailRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension MemoDetailRouting: MemoDetailRoutingInput {
    func showUpdateScreen(modelObject: MemoModelObject) {
        viewController?.show(
            AppControllers.Memo.Update(modelObject: modelObject),
            sender: nil
        )
    }
}
