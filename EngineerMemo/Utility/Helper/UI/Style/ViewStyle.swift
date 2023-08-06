import UIKit

struct ViewStyle<T> {
    let style: (T) -> Void

    init(style: @escaping (T) -> Void) {
        self.style = style
    }
}

protocol Stylable {}

extension Stylable {
    func apply(style: ViewStyle<Self>) {
        style.style(self)
    }
}

protocol ViewStylable: Stylable {}

extension ViewStylable where Self: UIView {
    @discardableResult
    func apply(_ style: ViewStyle<Self>) -> Self {
        apply(style: style)
        return self
    }
}

extension ViewStylable where Self: CALayer {
    @discardableResult
    func apply(_ style: ViewStyle<Self>) -> Self {
        apply(style: style)
        return self
    }
}

extension UIView: ViewStylable {}

extension CALayer: ViewStylable {}
