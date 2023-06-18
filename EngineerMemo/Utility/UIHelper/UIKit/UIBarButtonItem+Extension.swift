import Combine
import UIKit

extension UIBarButtonItem {
    enum IconBarButtonItemType {
        case addMemo
        case editMemo
        case deleteMemo

        var customButton: UIButton {
            .init(type: .system)
                .addConstraint {
                    $0.size.equalTo(32)
                }
                .configure {
                    $0.setImage(image, for: .normal)
                }
        }

        private var image: UIImage {
            let image: UIImage

            switch self {
            case .addMemo:
                image = Asset.memoAdd.image

            case .editMemo:
                image = Asset.memoEdit.image

            case .deleteMemo:
                image = Asset.memoDelete.image
            }

            return image.resized(size: size).withRenderingMode(.alwaysOriginal)
        }

        private var size: CGSize {
            .init(
                width: 32,
                height: 32
            )
        }
    }
}

extension UIBarButtonItem {
    var customButtonPublisher: AnyPublisher<UIButton, Never>? {
        (customView as? UIButton)?
            .publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
    }
}

extension UIBarButtonItem {
    convenience init(_ iconBarButtonItemType: IconBarButtonItemType) {
        self.init(customView: iconBarButtonItemType.customButton)
    }
}
