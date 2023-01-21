extension Int {
    var withDescription: String {
        self == -1 ? .noSetting : String(self)
    }

    static let invalid = -1
}
