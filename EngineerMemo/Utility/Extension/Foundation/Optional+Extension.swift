import Foundation

extension Optional {
    var isNil: Bool {
        self == nil
    }
}

extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        switch self {
        case let .some(value): value.isEmpty
        case .none: true
        }
    }
}

extension Optional where Wrapped: NSSet {
    var isEmtpy: Bool {
        switch self {
        case let .some(value): value.allObjects.isEmpty
        case .none: true
        }
    }
}
