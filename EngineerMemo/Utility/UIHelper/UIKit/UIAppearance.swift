import UIKit
import UIKitHelper

protocol UIAppearanceProtocol {
    func configureAppearance()
}

extension UIAppearanceProtocol {
    func configureAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .dynamicColor(light: .white, dark: .black)
            appearance.shadowColor = .clear
            appearance.backButtonAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.clear
            ]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .dynamicColor(light: .white, dark: .black)
            appearance.shadowColor = .clear
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
