import Foundation

extension Int {
    var withDescription: String {
        self == -1 ? .noSetting : String(self)
    }

    var boolValue: Bool {
        self == 0 ? true : false
    }

    var optionalBoolValue: Bool? {
        switch self {
        case 0: true
        case 1: false
        default: nil
        }
    }

    static let invalid = -1
}
