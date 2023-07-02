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
        case .profile: return L10n.Tab.profile
        case .memo: return L10n.Tab.memo
        case .setting: return L10n.Tab.setting
        }
    }

    var image: UIImage {
        switch self {
        case .profile: return Asset.profileTab.image
        case .memo: return Asset.memoTab.image
        case .setting: return Asset.settingTab.image
        }
    }

    var baseViewController: UIViewController {
        switch self {
        case .profile: return AppControllers.Profile.List()
        case .memo: return AppControllers.Memo.List()
        case .setting: return AppControllers.Setting()
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
}
