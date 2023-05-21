import UIKit

protocol Ally {
    func setupAlly()
}

extension Ally {
    func setupAlly() {
        let mirror = Mirror(reflecting: self)

        mirror.children.forEach { child in
            if let view = child.value as? UIView,
               let identifier = child.label?.replacingOccurrences(of: ".storage", with: "") {
                view.accessibilityIdentifier = "\(type(of: self)).\(identifier)"
            }
        }
    }
}

extension UIView: Ally {}
