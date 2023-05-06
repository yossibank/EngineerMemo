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
            var config = UIButton.Configuration.bordered()
            config.title = title
            config.image = nil
            config.baseForegroundColor = .primary
            config.imagePadding = .zero
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .boldSystemFont(ofSize: 15)
                return outgoing
            }
            config.background.backgroundColor = .background
            // NOTE: SnapshotTestで色変更がされないためlayerを変更する必要あり
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1.0
            $0.configuration = config
        }
    }

    private static func navigationDoneButton(title: String) -> ViewStyle<T> {
        .init {
            var config = UIButton.Configuration.bordered()
            config.title = title
            config.image = Asset.checkmark.image
                .resized(size: .init(width: 16, height: 16))
                .withRenderingMode(.alwaysOriginal)
            config.baseForegroundColor = .primary
            config.imagePadding = 2
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .boldSystemFont(ofSize: 15)
                return outgoing
            }
            config.background.backgroundColor = .background
            config.background.cornerRadius = 8
            config.background.strokeColor = .primary
            config.background.strokeWidth = 1.0
            $0.configuration = config
        }
    }
}

// MARK: - メモ

extension ViewStyle where T: UIButton {
    static var memoMenuButton: ViewStyle<T> {
        .init {
            var config = UIButton.Configuration.filled()
            config.baseForegroundColor = .primary
            config.imagePadding = 4
            config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .boldSystemFont(ofSize: 12)
                return outgoing
            }
            config.background.backgroundColor = .background
            config.background.cornerRadius = 8
            config.background.strokeColor = .primary
            config.background.strokeWidth = 1.0
            $0.configuration = config
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
            var config = UIButton.Configuration.filled()
            config.baseForegroundColor = .primary
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .boldSystemFont(ofSize: 14)
                return outgoing
            }
            config.background.backgroundColor = .background
            config.background.cornerRadius = 8
            config.background.strokeColor = .primary
            config.background.strokeWidth = 1.0
            $0.configuration = config
        }
    }

    private static func debugButton(title: String) -> ViewStyle<T> {
        .init {
            var config = UIButton.Configuration.filled()
            config.title = title
            config.image = nil
            config.baseForegroundColor = .primary
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .boldSystemFont(ofSize: 14)
                return outgoing
            }
            config.background.backgroundColor = .background
            config.background.cornerRadius = 8
            config.background.strokeColor = .primary
            config.background.strokeWidth = 1.0
            $0.configuration = config
        }
    }

    private static func debugButton(
        title: String,
        image: UIImage
    ) -> ViewStyle<T> {
        .init {
            var config = UIButton.Configuration.filled()
            config.title = title
            config.image = image
            config.baseForegroundColor = .primary
            config.imagePadding = 8
            config.imagePlacement = .trailing
            config.titleTextAttributesTransformer = .init { incoming in
                var outgoing = incoming
                outgoing.font = .boldSystemFont(ofSize: 14)
                return outgoing
            }
            config.background.backgroundColor = .background
            config.background.cornerRadius = 8
            config.background.strokeColor = .primary
            config.background.strokeWidth = 1.0
            $0.configuration = config
        }
    }
}
