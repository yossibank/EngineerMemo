import UIKit
import UIKitHelper

extension ViewStyle where T: UIButton {
    static var debugCreateButton: ViewStyle<T> {
        .init {
            $0.setTitle(L10n.Components.Button.create, for: .normal)
            $0.setTitleColor(.theme, for: .normal)
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }

    static var debugUpdateButton: ViewStyle<T> {
        .init {
            $0.setTitle(L10n.Components.Button.update, for: .normal)
            $0.setTitleColor(.theme, for: .normal)
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }

    static var debugMenuButton: ViewStyle<T> {
        .init {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.setTitleColor(.theme, for: .normal)
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
}
