import UIKit

extension ViewStyle where T: UITextField {
    // MARK: - プレースホルダー

    enum Placeholder {
        static var title: ViewStyle<T> {
            .init {
                $0.placeholder = "タイトル"
            }
        }

        static var body: ViewStyle<T> {
            .init {
                $0.placeholder = "内容"
            }
        }
    }

    // MARK: - スタイル

    static var round: ViewStyle<T> {
        .init {
            $0.borderStyle = .roundedRect
        }
    }
}
