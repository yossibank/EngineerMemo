import UIKit

enum MemoListCategoryType: CaseIterable {
    case all
    case todo
    case technical
    case interview
    case event
    case other
    case none

    var title: String {
        switch self {
        case .all: return L10n.Memo.Category.all
        case .todo: return L10n.Memo.Category.todo
        case .technical: return L10n.Memo.Category.technical
        case .interview: return L10n.Memo.Category.interview
        case .event: return L10n.Memo.Category.event
        case .other: return L10n.Memo.Category.other
        case .none: return L10n.Memo.Category.none
        }
    }

    var image: UIImage {
        switch self {
        case .all: return Asset.allCategory.image
        case .todo: return Asset.toDoCategory.image
        case .technical: return Asset.technicalCategory.image
        case .interview: return Asset.interviewCategory.image
        case .event: return Asset.eventCategory.image
        case .other: return Asset.otherCategory.image
        case .none: return Asset.noneCategory.image
        }
    }
}

enum MemoInputCategoryType: CaseIterable {
    case todo
    case technical
    case interview
    case event
    case other
    case noSetting

    var title: String {
        switch self {
        case .todo: return L10n.Memo.Category.todo
        case .technical: return L10n.Memo.Category.technical
        case .interview: return L10n.Memo.Category.interview
        case .event: return L10n.Memo.Category.event
        case .other: return L10n.Memo.Category.other
        case .noSetting: return .noSetting
        }
    }

    var image: UIImage? {
        switch self {
        case .todo: return Asset.toDoCategory.image
        case .technical: return Asset.technicalCategory.image
        case .interview: return Asset.interviewCategory.image
        case .event: return Asset.eventCategory.image
        case .other: return Asset.otherCategory.image
        case .noSetting: return nil
        }
    }
}
