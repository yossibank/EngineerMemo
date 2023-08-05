import Foundation

extension String {
    var phoneText: String {
        guard Int(self) != nil else {
            return .noSetting
        }

        var phoneNumber = self
        phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 3))
        phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 8))
        return phoneNumber
    }

    var notNoSettingText: String? {
        self == .noSetting ? nil : self
    }

    func `repeat`(_ count: Int) -> String {
        String(repeating: self, count: count)
    }

    static let empty = ""
    static let emptyWord = "空文字"
    static let nilWord = "nil"
    static let noSetting = "未設定"
    static let unknown = "不明"

    static func randomElement(_ length: Int) -> String {
        let elements = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        var randomString = empty

        for _ in 0 ..< length {
            randomString += String(elements.randomElement()!)
        }

        return randomString
    }
}
