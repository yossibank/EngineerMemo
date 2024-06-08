enum FAParameter: String {
    case screenId
    case memoTitle

    var rawValue: String {
        switch self {
        case .screenId: L10n.Fa.Parameter.screenId
        case .memoTitle: L10n.Fa.Parameter.memoTitle
        }
    }
}
