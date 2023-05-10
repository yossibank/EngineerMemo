import UIKit

enum ItemType {
    case reload
    case addMemo

    var image: UIImage {
        let image: UIImage

        switch self {
        case .reload:
            image = Asset.reload.image

        case .addMemo:
            image = Asset.addMemo.image
        }

        return image.resized(size: size).withRenderingMode(.alwaysOriginal)
    }

    var size: CGSize {
        switch self {
        case .reload:
            return .init(width: 28, height: 28)

        case .addMemo:
            return .init(width: 32, height: 32)
        }
    }
}

extension UIBarButtonItem {
    convenience init(_ itemType: ItemType) {
        self.init(
            image: itemType.image,
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
