import Foundation

extension NSObject {
    static var className: String {
        String(describing: self)
    }

    var className: String {
        String(describing: type(of: self))
    }
}
