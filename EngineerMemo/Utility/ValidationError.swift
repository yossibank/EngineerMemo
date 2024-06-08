enum ValidationError {
    case none
    case empty
    case long

    var isEnabled: Bool {
        self == .none
    }

    var description: String {
        switch self {
        case .none: .empty
        case .empty: "文字が入力されていません。"
        case .long: "入力された文字が長すぎます。20文字以内でご入力ください。"
        }
    }
}

enum ValidationType {
    case title(ValidationError)
    case body(ValidationError)
}
