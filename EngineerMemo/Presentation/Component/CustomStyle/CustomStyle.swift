import UIKit
import UIKitHelper

// MARK: - 入力

extension ViewStyle where T: UIView {
    static var inputView: ViewStyle<T> {
        .init {
            $0.backgroundColor = .primaryGray
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }
    }
}

// MARK: - ナビゲーションバー

extension ViewStyle where T: UIButton {
    static var createNavigationButton: ViewStyle<T> {
        navigationButton(title: L10n.Components.Button.create)
    }

    static var createDoneNavigationButton: ViewStyle<T> {
        navigationDoneButton(title: L10n.Components.Button.create)
    }

    static var updateNavigationButton: ViewStyle<T> {
        navigationButton(title: L10n.Components.Button.update)
    }

    static var updateDoneNavigationButton: ViewStyle<T> {
        navigationDoneButton(title: L10n.Components.Button.update)
    }

    static var settingNavigationButton: ViewStyle<T> {
        navigationButton(title: L10n.Components.Button.setting)
    }

    static var settingDoneNavigationButton: ViewStyle<T> {
        navigationDoneButton(title: L10n.Components.Button.setting)
    }

    static var sendNavigationButton: ViewStyle<T> {
        navigationButton(title: L10n.Components.Button.send)
    }

    private static func navigationButton(title: String) -> ViewStyle<T> {
        .init {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.primary, for: .normal)
            $0.setImage(nil, for: .normal)
            $0.imageEdgeInsets = .zero
            $0.titleEdgeInsets = .zero
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1.0
        }
    }

    private static func navigationDoneButton(title: String) -> ViewStyle<T> {
        .init {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.primary, for: .normal)
            $0.setImage(
                Asset.checkmark.image
                    .resized(size: .init(width: 20, height: 20))
                    .withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            $0.imageEdgeInsets = .init(.left, -8)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1.0
            $0.clipsToBounds = true
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
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.primary, for: .normal)
            $0.setImage(image?.resized(size: .init(width: 20, height: 20)), for: .normal)
            $0.contentEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
            $0.imageEdgeInsets = .init(.left, -8)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.tintColor = .dynamicColor(light: .blue, dark: .green)
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
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
            image: Asset.checkmark.image
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
            image: Asset.checkmark.image
                .resized(size: .init(width: 20, height: 20))
                .withRenderingMode(.alwaysOriginal)
        )
    }

    static var debugMenuButton: ViewStyle<T> {
        .init {
            $0.setTitleColor(.primary, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }

    private static func debugButton(title: String) -> ViewStyle<T> {
        .init {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.primary, for: .normal)
            $0.setImage(nil, for: .normal)
            $0.imageEdgeInsets = .zero
            $0.titleEdgeInsets = .zero
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1.0
            $0.clipsToBounds = true
        }
    }

    private static func debugButton(
        title: String,
        image: UIImage
    ) -> ViewStyle<T> {
        .init {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.primary, for: .normal)
            $0.setImage(image, for: .normal)
            $0.imageEdgeInsets = .init(.left, 120)
            $0.titleEdgeInsets = .init(.right, 20)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1.0
            $0.clipsToBounds = true
        }
    }
}
