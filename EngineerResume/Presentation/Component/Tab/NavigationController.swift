import UIKit

final class NavigationController: UINavigationController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewControllers.forEach {
            $0.navigationItem.backBarButtonItem = .init(
                title: "",
                style: .plain,
                target: nil,
                action: nil
            )
        }
    }
}
