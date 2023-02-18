import UIKit

extension UICollectionView {
    func registerReusableView<T: UICollectionReusableView>(with type: T.Type) {
        register(
            type,
            forSupplementaryViewOfKind: T.className,
            withReuseIdentifier: T.className
        )
    }
}

extension UICollectionView.SupplementaryRegistration {
    init(handler: @escaping Handler) {
        self.init(
            elementKind: Supplementary.className,
            handler: handler
        )
    }
}
