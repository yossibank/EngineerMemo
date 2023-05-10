import Combine
import UIKit

extension UIBarButtonItem {
    enum BarButtonItemType {
        case reload
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
            case .reload:
                image = Asset.reload.image

            case .addMemo:
                image = Asset.addMemo.image

            case .editMemo:
                image = Asset.editMemo.image

            case .deleteMemo:
                image = Asset.deleteMemo.image
            }

            return image.resized(size: size).withRenderingMode(.alwaysOriginal)
        }

        private var size: CGSize {
            switch self {
            case .reload:
                return .init(width: 28, height: 28)

            case .addMemo, .editMemo, .deleteMemo:
                return .init(width: 32, height: 32)
            }
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
    convenience init(_ barButtonItemType: BarButtonItemType) {
        self.init(customView: barButtonItemType.customButton)
    }
}
