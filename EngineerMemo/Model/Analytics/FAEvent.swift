enum FAEvent: Equatable {
    case screenView
    case didTapMemoList(title: String)

    var name: String {
        switch self {
        case .screenView:
            return L10n.Fa.EventName.screenView

        case .didTapMemoList:
            return L10n.Fa.EventName.didTapMemoList
        }
    }

    var parameter: [String: Any] {
        var params = [FAParameter: Any]()

        switch self {
        case .screenView:
            break

        case let .didTapMemoList(title):
            params[.memoTitle] = title
        }

        return params.reduce(into: [String: Any]()) {
            $0[$1.key.rawValue] = $1.value
        }
    }
}
