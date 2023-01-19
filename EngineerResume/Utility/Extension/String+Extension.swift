extension String {
    static let noSetting = "未設定"
    static let unknown = "不明"

    static func randomElement(_ length: Int) -> String {
        let elements = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        var randomString = ""

        for _ in 0 ..< length {
            randomString += String(elements.randomElement()!)
        }

        return randomString
    }
}
