import UIKit

/// @mockable
protocol SettingRoutingInput {
    func showLicenceScreen()
}

// MARK: - properties & init

final class SettingRouting {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - protocol

extension SettingRouting: SettingRoutingInput {
    func showLicenceScreen() {
        viewController?.show(
            AppControllers.Setting.Licence(),
            sender: nil
        )
    }
}
