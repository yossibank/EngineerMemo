import UIKit

final class TabBarController: UITabBarController {
    private enum TabItem: Int, CaseIterable {
        case home
        case profile
        case memo
        case debug

        var rootViewController: UIViewController {
            let rootViewController: UINavigationController

            switch self {
            case .home:
                rootViewController = .init(rootViewController: AppControllers.Sample.List())

            case .profile:
                rootViewController = .init(rootViewController: AppControllers.Profile.Detail())

            case .memo:
                rootViewController = .init(rootViewController: AppControllers.Memo.List())

            case .debug:
                rootViewController = .init(rootViewController: AppControllers.Debug.Development())
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

            case .memo:
                return L10n.Tab.memo

            case .debug:
                return L10n.Tab.debug
            }
        }

        private var image: UIImage? {
            switch self {
            case .home:
                return ImageResources.house

            case .profile:
                return ImageResources.profile

            case .memo:
                return ImageResources.memo

            case .debug:
                return ImageResources.debug
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
