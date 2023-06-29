import UIKit

enum ProjectContentType: CaseIterable {
    case title
    case content

    var title: String {
        switch self {
        case .title: return L10n.Profile.Project.title
        case .content: return L10n.Profile.Project.content
        }
    }

    var image: UIImage {
        switch self {
        case .title: return Asset.projectTitle.image
        case .content: return Asset.projectContent.image
        }
    }
}
