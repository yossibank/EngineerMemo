import UIKit

@resultBuilder
enum StackViewBuilder {
    static func buildBlock(_ views: UIView...) -> [UIView] {
        views
    }

    static func buildBlock(_ view: UIView) -> UIView {
        view
    }
}
