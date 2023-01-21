import UIKit

extension UITableView {
    func registerCell(with type: UITableViewCell.Type) {
        register(
            type,
            forCellReuseIdentifier: String(describing: type)
        )
    }

    func registerCells(with types: [UITableViewCell.Type]) {
        types.forEach {
            registerCell(with: $0)
        }
    }

    func registerHeaderFooterView(with type: UITableViewHeaderFooterView.Type) {
        register(
            type,
            forHeaderFooterViewReuseIdentifier: String(describing: type)
        )
    }

    func registerHeaderFooterViews(with types: [UITableViewHeaderFooterView.Type]) {
        types.forEach {
            registerHeaderFooterView(with: $0)
        }
    }

    func dequeueReusableCell<T: UITableViewCell>(
        withType type: T.Type,
        for indexPath: IndexPath
    ) -> T {
        dequeueReusableCell(
            withIdentifier: String(describing: type),
            for: indexPath
        ) as! T
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        withType type: T.Type
    ) -> T {
        dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: type)
        ) as! T
    }
}
