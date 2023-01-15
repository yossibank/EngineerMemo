import UIKit

extension UIDevice {
    static var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? .unknown
    }
}
