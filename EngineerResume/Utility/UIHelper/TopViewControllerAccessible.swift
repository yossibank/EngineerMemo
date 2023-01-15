import UIKit

protocol TopViewControllerAccessible {}

extension UIView: TopViewControllerAccessible {}

extension UIViewController: TopViewControllerAccessible {}

extension TopViewControllerAccessible {
    var rootViewController: UIViewController? {
        let rootViewController: UIViewController?

        if #available(iOS 15.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            rootViewController = windowScene?.windows.first?.rootViewController
        } else {
            rootViewController = UIApplication.shared.windows.first?.rootViewController
        }

        return rootViewController
    }

    var topViewController: UIViewController? {
        var topViewController = rootViewController

        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    }

    var visibleViewController: UIViewController? {
        guard let rootViewController else {
            return nil
        }

        return getVisibleViewController(rootViewController)
    }
}

private extension TopViewControllerAccessible {
    func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }

        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }

        if let tabBarController = rootViewController as? UITabBarController {
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                let visible = navigationController.visibleViewController

                if visible is UISearchController || visible is UIAlertController {
                    return visible?.presentingViewController ?? visible?.parent
                }

                return visible
            }

            return tabBarController.selectedViewController
        }

        return rootViewController
    }
}
