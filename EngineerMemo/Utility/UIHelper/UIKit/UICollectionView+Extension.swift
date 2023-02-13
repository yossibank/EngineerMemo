import UIKit

extension UICollectionView {
    func registerReusableView(with type: UICollectionReusableView.Type) {
        register(
            type,
            forSupplementaryViewOfKind: String(describing: type),
            withReuseIdentifier: String(describing: type)
        )
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        withType type: T.Type,
        for indexPath: IndexPath
    ) -> T {
        dequeueReusableSupplementaryView(
            ofKind: String(describing: type),
            withReuseIdentifier: String(describing: type),
            for: indexPath
        ) as! T
    }
}
