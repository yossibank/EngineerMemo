import UIKit

enum MemoListCategoryType: CaseIterable {
    case all
    case todo
    case technical
    case interview
    case event
    case tax
    case other
    case none

    var title: String {
        switch self {
        case .all: L10n.Memo.Category.all
        case .todo: L10n.Memo.Category.todo
        case .technical: L10n.Memo.Category.technical
        case .interview: L10n.Memo.Category.interview
        case .event: L10n.Memo.Category.event
        case .tax: L10n.Memo.Category.tax
        case .other: L10n.Memo.Category.other
        case .none: L10n.Memo.Category.none
        }
    }

    var image: UIImage {
        switch self {
        case .all: Asset.allCategory.image
        case .todo: Asset.toDoCategory.image
        case .technical: Asset.technicalCategory.image
        case .interview: Asset.interviewCategory.image
        case .event: Asset.eventCategory.image
        case .tax: Asset.taxCategory.image
        case .other: Asset.otherCategory.image
        case .none: Asset.noneCategory.image
        }
    }
}

enum MemoListSortType: CaseIterable {
    case descending
    case ascending

    var title: String {
        switch self {
        case .descending: L10n.Memo.Sort.descendingDate
        case .ascending: L10n.Memo.Sort.ascendingDate
        }
    }

    var image: UIImage {
        switch self {
        case .descending: Asset.descendingDate.image
        case .ascending: Asset.ascendingDate.image
        }
    }
}

enum MemoInputCategoryType: CaseIterable {
    case todo
    case technical
    case interview
    case event
    case tax
    case other
    case widget
    case noSetting

    var title: String {
        switch self {
        case .todo: L10n.Memo.Category.todo
        case .technical: L10n.Memo.Category.technical
        case .interview: L10n.Memo.Category.interview
        case .event: L10n.Memo.Category.event
        case .tax: L10n.Memo.Category.tax
        case .other: L10n.Memo.Category.other
        case .widget: L10n.Memo.Category.widget
        case .noSetting: .noSetting
        }
    }

    var image: UIImage? {
        switch self {
        case .todo: Asset.toDoCategory.image
        case .technical: Asset.technicalCategory.image
        case .interview: Asset.interviewCategory.image
        case .event: Asset.eventCategory.image
        case .tax: Asset.taxCategory.image
        case .other: Asset.otherCategory.image
        case .widget: Asset.widgetCategory.image
        case .noSetting: nil
        }
    }

    var category: MemoModelObject.Category? {
        switch self {
        case .todo: .todo
        case .technical: .technical
        case .interview: .interview
        case .event: .event
        case .tax: .tax
        case .other: .other
        case .widget: .widget
        case .noSetting: .none
        }
    }
}
