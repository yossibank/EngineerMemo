import Foundation

extension Int {
    var withDescription: String {
        self == -1 ? .noSetting : String(self)
    }

    var boolValue: Bool {
        self == 0 ? true : false
    }

    static let invalid = -1
}
