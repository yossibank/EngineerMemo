import UIKit

extension UICollectionView {
    func registerCell(with type: UICollectionViewCell.Type) {
        register(
            type,
            forCellWithReuseIdentifier: String(describing: type)
        )
    }

    func registerCells(with types: [UICollectionViewCell.Type]) {
        types.forEach {
            registerCell(with: $0)
        }
    }

    func registerReusableView<T: UICollectionReusableView>(with type: T.Type) {
        register(
            type,
            forSupplementaryViewOfKind: T.className,
            withReuseIdentifier: T.className
        )
    }

    func dequeueReusableCell<T: UICollectionViewCell>(
        withType type: T.Type,
        for indexPath: IndexPath
    ) -> T {
        dequeueReusableCell(
            withReuseIdentifier: String(describing: type),
            for: indexPath
        ) as! T
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
