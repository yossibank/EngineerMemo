enum MemoContentType: CaseIterable {
    case category
    case title
    case content

    var title: String {
        switch self {
        case .category: return L10n.Memo.category
        case .title: return L10n.Memo.title
        case .content: return L10n.Memo.content
        }
    }
}
