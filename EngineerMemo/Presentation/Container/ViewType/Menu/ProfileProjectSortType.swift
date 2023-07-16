import UIKit

extension DataHolder.ProfileProjectSortType {
    var title: String {
        switch self {
        case .descending: return L10n.Project.Sort.descendingDate
        case .ascending: return L10n.Project.Sort.ascendingDate
        }
    }

    var image: UIImage {
        switch self {
        case .descending: return Asset.descendingDate.image
        case .ascending: return Asset.ascendingDate.image
        }
    }
}
