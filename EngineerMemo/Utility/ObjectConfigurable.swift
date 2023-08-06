import Foundation

protocol ObjectConfigurable {}

extension ObjectConfigurable {
    @discardableResult
    func configure(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

extension NSObject: ObjectConfigurable {}
