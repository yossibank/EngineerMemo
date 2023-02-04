import UIKit
import UIStyle

extension UIStyle where T: UIButton {
    static func edit(title: String, image: UIImage?) -> [UIStyle<T>] {
        [
            .boldSystemFont(size: 12),
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(8),
            .contentEdgeInsets(.init(top: 4, left: 8, bottom: 4, right: 8)),
            .imageEdgeInsets(.left, -8),
            .setTitle(title),
            .setTitleColor(.theme),
            .setImage(image?.resized(size: .init(width: 16, height: 16))),
            .tintColor(.theme)
        ]
    }
}
