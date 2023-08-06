import Foundation

extension Optional {
    var isNil: Bool {
        self == nil
    }
}

extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        switch self {
        case let .some(value):
            return value.isEmpty

        case .none:
            return true
        }
    }
}

extension Optional where Wrapped: NSSet {
    var isEmtpy: Bool {
        switch self {
        case let .some(value):
            return value.allObjects.isEmpty

        case .none:
            return true
        }
    }
}
