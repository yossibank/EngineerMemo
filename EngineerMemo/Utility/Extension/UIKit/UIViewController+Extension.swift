import UIKit

extension UIViewController {
    func showActionSheet(
        title: String? = nil,
        message: String? = nil,
        actions: [SheetAction] = []
    ) {
        navigationController?.definesPresentationContext = false

        var actions = actions
        actions.append(.closeAction)

        present(
            AppControllers.Sheet(
                .init(
                    title: title,
                    message: message,
                    actions: actions
                )
            ),
            animated: true
        )
    }
}

extension UIViewController {
    func addSubviewController(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeSubviewController(child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }

    func removeFirstChild() {
        if let firstChild = children.first {
            removeSubviewController(child: firstChild)
        }
    }
}
