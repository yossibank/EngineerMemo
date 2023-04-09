import UIKit
import UIKitHelper

// MARK: - 入力

extension ViewStyle where T: UIView {
    static var inputView: ViewStyle<T> {
        .init {
            $0.backgroundColor = .thinGray
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4
        }
    }
}

// MARK: - メモ

extension ViewStyle where T: UIButton {
    static var memoCreateButton: ViewStyle<T> {
        memoButton(
            title: L10n.Components.Button.create,
            image: ImageResources.Memo.add
        )
    }

    static var memoCreateDoneButton: ViewStyle<T> {
        .init {
            $0.setTitle(
                "作成",
                for: .normal
            )
            $0.setTitleColor(
                .theme,
                for: .normal
            )
            $0.setImage(
                Asset.check.image
                    .resized(size: .init(width: 20, height: 20))
                    .withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            $0.imageEdgeInsets = .init(.left, 55)
            $0.titleEdgeInsets = .init(.right, 20)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        }
    }

    static var memoDeleteButton: ViewStyle<T> {
        memoButton(
            title: L10n.Components.Button.delete,
            image: ImageResources.Memo.delete
        )
    }

    private static func memoButton(
        title: String,
        image: UIImage?
    ) -> ViewStyle<T> {
        .init {
            $0.setTitle(
                title,
                for: .normal
            )
            $0.setTitleColor(
                .theme,
                for: .normal
            )
            $0.setImage(
                image?.resized(size: .init(width: 20, height: 20)),
                for: .normal
            )
            $0.clipsToBounds = true
            $0.contentEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
            $0.imageEdgeInsets = .init(.left, -8)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
        }
    }
}

// MARK: - デバッグ

extension ViewStyle where T: UIButton {
    static var debugCreateButton: ViewStyle<T> {
        debugButton(title: L10n.Components.Button.Do.create)
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
        debugButton(title: L10n.Components.Button.Do.update)
    }

    static var debugUpdateDoneButton: ViewStyle<T> {
        debugButton(
            title: L10n.Components.Button.updateDone,
            image: Asset.check.image
                .resized(size: .init(width: 20, height: 20))
                .withRenderingMode(.alwaysOriginal)
        )
    }

    static var debugMenuButton: ViewStyle<T> {
        .init {
            $0.setTitleColor(
                .theme,
                for: .normal
            )
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }

    private static func debugButton(title: String) -> ViewStyle<T> {
        .init {
            $0.setTitle(
                title,
                for: .normal
            )
            $0.setTitleColor(
                .theme,
                for: .normal
            )
            $0.setImage(
                nil,
                for: .normal
            )
            $0.clipsToBounds = true
            $0.imageEdgeInsets = .zero
            $0.titleEdgeInsets = .zero
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
        }
    }

    private static func debugButton(
        title: String,
        image: UIImage
    ) -> ViewStyle<T> {
        .init {
            $0.setTitle(
                title,
                for: .normal
            )
            $0.setTitleColor(
                .theme,
                for: .normal
            )
            $0.setImage(
                image,
                for: .normal
            )
            $0.clipsToBounds = true
            $0.imageEdgeInsets = .init(.left, 120)
            $0.titleEdgeInsets = .init(.right, 20)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.theme.cgColor
            $0.layer.borderWidth = 1.0
        }
    }
}
