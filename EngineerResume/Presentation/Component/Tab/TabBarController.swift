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
                rootViewController = .init(rootViewController: AppControllers.Sample.List())
            }

            rootViewController.tabBarItem = tabBarItem

            return rootViewController
        }

        private var title: String {
            switch self {
            case .home:
                return "ホーム"

            case .profile:
                return "プロフィール"
            }
        }

        private var image: UIImage? {
            switch self {
            case .home:
                return .init(systemName: "house")

            case .profile:
                return .init(systemName: "person.crop.circle")
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
