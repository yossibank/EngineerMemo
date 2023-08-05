import UIKit

protocol TopViewControllerAccessible {}

extension TopViewControllerAccessible {
    public var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
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

extension UIView: TopViewControllerAccessible {}

extension UIViewController: TopViewControllerAccessible {}
