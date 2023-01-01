import UIKit

extension Stylable where Self == UIButton {
    init(style: ViewStyle<Self>) {
        self.init(type: .system)
        apply(style)
    }

    init(styles: [ViewStyle<Self>]) {
        self.init(type: .system)
        styles.forEach { apply($0) }
    }
}

extension ViewStyle where T: UIButton {
    // MARK: - 文字タイトル

    enum ButtonTitle {
        static var create: ViewStyle<T> {
            .init {
                $0.setTitle("作成する", for: .normal)
            }
        }

        static var edit: ViewStyle<T> {
            .init {
                $0.setTitle("編集する", for: .normal)
            }
        }
    }

    // MARK: - タイトルカラー

    static var titlePrimary: ViewStyle<T> {
        .init {
            $0.setTitleColor(
                .dynamicColor(light: .black, dark: .white),
                for: .normal
            )
        }
    }
}
