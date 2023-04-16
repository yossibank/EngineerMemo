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
