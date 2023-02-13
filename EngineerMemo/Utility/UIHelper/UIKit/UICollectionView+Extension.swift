import UIKit

extension UICollectionView {
    func registerReusableView(with type: UICollectionReusableView.Type) {
        register(
            type,
            forSupplementaryViewOfKind: String(describing: type),
            withReuseIdentifier: String(describing: type)
        )
    }
}

extension UICollectionView.SupplementaryRegistration {
    init(handler: @escaping Handler) {
        self.init(
            elementKind: String(describing: Supplementary.self),
            handler: handler
        )
    }
}
