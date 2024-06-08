import UIKit

enum TabItem: Int, CaseIterable {
    case profile
    case memo
    case setting

    var rootViewController: UIViewController {
        let rootViewController = UINavigationController(
            rootViewController: baseViewController
        )

        rootViewController.tabBarItem = .init(
            title: title,
            image: image
                .resized(size: .init(width: 24, height: 24))
                .withRenderingMode(.alwaysOriginal),
            tag: rawValue
        )

        return rootViewController
    }

    var title: String {
        switch self {
        case .profile: L10n.Tab.profile
        case .memo: L10n.Tab.memo
        case .setting: L10n.Tab.setting
        }
    }

    var image: UIImage {
        switch self {
        case .profile: Asset.profileTab.image
        case .memo: Asset.memoTab.image
        case .setting: Asset.settingTab.image
        }
    }

    var baseViewController: UIViewController {
        switch self {
        case .profile: AppControllers.Profile.List()
        case .memo: AppControllers.Memo.List()
        case .setting: AppControllers.Setting.List()
        }
    }
}

#if DEBUG
    private enum DebugTabItem: Int, CaseIterable {
        case debug = 3

        var rootViewController: UIViewController {
            let rootViewController = UINavigationController(
                rootViewController: AppControllers.Debug.Development()
            )

            rootViewController.tabBarItem = .init(
                title: L10n.Tab.debug,
                image: Asset.developmentTab.image
                    .resized(size: .init(width: 24, height: 24))
                    .withRenderingMode(.alwaysOriginal),
                tag: rawValue
            )

            return rootViewController
        }
    }
#endif

// MARK: - override methods

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

    func transitionURLScheme(
        _ appURLScheme: AppURLScheme,
        url: URL
    ) {
        guard
            let visibleViewController,
            let viewController = appURLScheme.transitionViewController(url: url),
            viewController.className != visibleViewController.className
        else {
            return
        }

        switch appURLScheme {
        case .memoDetail, .memoCreate:
            selectedIndex = TabItem.memo.rawValue
        }

        (selectedViewController as? UINavigationController)?.pushViewController(
            viewController,
            animated: true
        )
    }
}
