import UIKit

final class TabBarController: UITabBarController {
    private enum TabItem: Int, CaseIterable {
        case home
        case profile

        var rootViewController: UIViewController {
            let rootViewController: UINavigationController

            switch self {
            case .home:
                rootViewController = .init(rootViewController: AppControllers.Sample.List())

            case .profile:
                rootViewController = .init(rootViewController: AppControllers.Profile.Detail())
            }

            rootViewController.tabBarItem = tabBarItem

            return rootViewController
        }

        private var title: String {
            switch self {
            case .home:
                return L10n.Tab.home

            case .profile:
                return L10n.Tab.profile
            }
        }

        private var image: UIImage? {
            switch self {
            case .home:
                return ImageResources.house

            case .profile:
                return ImageResources.profile
            }
        }

        private var tabBarItem: UITabBarItem {
            .init(title: title, image: image, tag: rawValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers(
            TabItem.allCases.map(\.rootViewController),
            animated: false
        )
    }
}
