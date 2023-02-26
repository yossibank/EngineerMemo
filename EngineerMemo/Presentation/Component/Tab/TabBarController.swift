import UIKit

private enum TabItem: Int, CaseIterable {
    case profile
    case memo

    var rootViewController: UIViewController {
        let rootViewController: UINavigationController
        let title: String
        let image: UIImage?

        switch self {
        case .profile:
            rootViewController = .init(rootViewController: AppControllers.Profile.Detail())
            title = L10n.Tab.profile
            image = ImageResources.profile

        case .memo:
            rootViewController = .init(rootViewController: AppControllers.Memo.List())
            title = L10n.Tab.memo
            image = ImageResources.memo
        }

        rootViewController.tabBarItem = .init(
            title: title,
            image: image,
            tag: rawValue
        )

        return rootViewController
    }
}

#if DEBUG
    private enum DebugTabItem: Int, CaseIterable {
        case debug = 2

        var rootViewController: UIViewController {
            let rootViewController = UINavigationController(
                rootViewController: AppControllers.Debug.Development()
            )

            rootViewController.tabBarItem = .init(
                title: L10n.Tab.debug,
                image: ImageResources.debug,
                tag: rawValue
            )

            return rootViewController
        }
    }
#endif

// MARK: - properties & init

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        var viewControllers = TabItem.allCases.map(\.rootViewController)

        #if DEBUG
            viewControllers.append(contentsOf: DebugTabItem.allCases.map(\.rootViewController))
        #endif

        setViewControllers(
            viewControllers,
            animated: false
        )
    }
}
