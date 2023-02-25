import UIKit

extension UIEdgeInsets {
    enum EdgeInsetsDirection {
        case top
        case left
        case bottom
        case right
        case horizontal
        case vertical
    }

    init(_ direction: EdgeInsetsDirection, _ padding: CGFloat) {
        switch direction {
        case .top:
            self.init(top: padding, left: .zero, bottom: .zero, right: .zero)

        case .bottom:
            self.init(top: .zero, left: .zero, bottom: padding, right: .zero)

        case .left:
            self.init(top: .zero, left: padding, bottom: .zero, right: .zero)

        case .right:
            self.init(top: .zero, left: .zero, bottom: .zero, right: padding)

        case .horizontal:
            self.init(top: .zero, left: padding, bottom: .zero, right: padding)

        case .vertical:
            self.init(top: padding, left: .zero, bottom: padding, right: .zero)
        }
    }
}
