enum UserDefaultsKey: String, CaseIterable {
    case sample
}

enum UserDefaultsEnum {
    enum Sample: Int, UserDefaultsCompatible {
        case sample1
        case sample2
        case sample3
    }
}
