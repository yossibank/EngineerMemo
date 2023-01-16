import UIKit

protocol ContentViewControllerAccessible: TopViewControllerAccessible {}

extension ContentViewControllerAccessible {
    func myViewController<T: UIViewController>(_ type: T.Type) -> T? {
        visibleViewController as? T
    }
}
