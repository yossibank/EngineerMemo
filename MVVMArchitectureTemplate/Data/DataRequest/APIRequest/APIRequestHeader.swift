enum APIRequestHeader: String, CaseIterable {
    case contentType = "Content-Type"

    var value: String {
        switch self {
        case .contentType:
            return "application/json"
        }
    }
}
