import UIKit

extension ViewStyle where T: UIImageView {
    // MARK: - 画像

    enum Image {
        static var postOffice: ViewStyle<T> {
            .init {
                $0.image = Asset.postOffice.image
            }
        }
    }

    // MARK: - 画像リサイズ

    static var size16: ViewStyle<T> {
        .init {
            $0.image = $0.image?.resized(
                size: .init(
                    width: 16,
                    height: 16
                )
            )
        }
    }
}
