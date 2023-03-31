import UIKit
import UIKitHelper

extension ViewStyle where T: UIButton {
    static var debugAddButton: ViewStyle<T> {
        debugButton(title: L10n.Components.Button.add)
    }

    static var debugDeleteButton: ViewStyle<T> {
        debugButton(title: L10n.Components.Button.delete)
    }

    static var debugCreateButton: ViewStyle<T> {
        debugButton(title: L10n.Components.Button.create)
    }

    static var debugCreateDoneButton: ViewStyle<T> {
        debugButton(
            title: L10n.Components.Button.createDone,
            image: Asset.check.image
                .resized(size: .init(width: 20, height: 20))
                .withRenderingMode(.alwaysOriginal)
        )
    }

    static var debugUpdateButton: ViewStyle<T> {
        debugButton(title: L10n.Components.Button.update)
    }

    static var debugUpdateDoneButton: ViewStyle<T> {
        debugButton(
            title: L10n.Components.Button.updateDone,
            image: Asset.check.image
                .resized(size: .init(width: 20, height: 20))
                .withRenderingMode(.alwaysOriginal)
        )
    }

    static var debugNilButton: ViewStyle<T> {
        debugButton(title: L10n.Components.Button.nil)
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

    private static func debugButton(title: String) -> ViewStyle<T> {
        .init {
            $0.imageEdgeInsets = .zero
            $0.titleEdgeInsets = .zero
            $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.theme, for: .normal)
            $0.setImage(nil, for: .normal)
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }

    private static func debugButton(
        title: String,
        image: UIImage
    ) -> ViewStyle<T> {
        .init {
            $0.imageEdgeInsets = .init(.left, 120)
            $0.titleEdgeInsets = .init(.right, 20)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.theme, for: .normal)
            $0.setImage(image, for: .normal)
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
}
