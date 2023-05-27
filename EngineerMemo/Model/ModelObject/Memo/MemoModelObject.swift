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

        var value: String {
            switch self {
            case .todo: return L10n.Memo.Category.todo
            case .technical: return L10n.Memo.Category.technical
            case .interview: return L10n.Memo.Category.interview
            case .event: return L10n.Memo.Category.event
            case .tax: return L10n.Memo.Category.tax
            case .other: return L10n.Memo.Category.other
            }
        }
    }
}

extension MemoModelObject {
    func dataInsert(
        _ memo: Memo,
        isNew: Bool
    ) {
        memo.category = .init(rawValue: category?.rawValue ?? .invalid)
        memo.title = title
        memo.content = content
        memo.createdAt = createdAt

        if isNew {
            memo.identifier = UUID().uuidString
        }
    }
}
