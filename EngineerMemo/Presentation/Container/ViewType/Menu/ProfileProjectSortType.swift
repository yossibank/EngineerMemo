import UIKit

extension DataHolder.ProfileProjectSortType {
    var title: String {
        switch self {
        case .descending: L10n.Project.Sort.descendingDate
        case .ascending: L10n.Project.Sort.ascendingDate
        }
    }

    var image: UIImage {
        switch self {
        case .descending: Asset.descendingDate.image
        case .ascending: Asset.ascendingDate.image
        }
    }
}
