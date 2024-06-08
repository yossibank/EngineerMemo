import Foundation

struct MemoModelObject: Hashable {
    var category: Category?
    var title: String?
    var content: String?
    var createdAt: Date
    var identifier: String

    enum Category: Int {
        case todo
        case technical
        case interview
        case event
        case tax
        case other
        case widget

        var value: String {
            switch self {
            case .todo: L10n.Memo.Category.todo
            case .technical: L10n.Memo.Category.technical
            case .interview: L10n.Memo.Category.interview
            case .event: L10n.Memo.Category.event
            case .tax: L10n.Memo.Category.tax
            case .other: L10n.Memo.Category.other
            case .widget: L10n.Memo.Category.widget
            }
        }
    }
}

extension MemoModelObject {
    func insertMemo(
        _ memo: CoreDataObject<Memo>,
        isNew: Bool
    ) {
        let context = memo.context
        let memo = memo.object

        memo.category = .init(rawValue: category?.rawValue ?? .invalid)
        memo.title = title
        memo.content = content

        if isNew {
            memo.createdAt = createdAt
            memo.identifier = UUID().uuidString
        }

        context.saveIfNeeded()
    }
}
