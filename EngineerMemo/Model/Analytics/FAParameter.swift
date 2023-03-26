enum FAParameter: String {
    case screenId
    case memoTitle

    var rawValue: String {
        switch self {
        case .screenId:
            return L10n.Fa.Parameter.screenId

        case .memoTitle:
            return L10n.Fa.Parameter.memoTitle
        }
    }
}
