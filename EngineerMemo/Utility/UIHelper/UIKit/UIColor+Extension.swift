import UIKit
import UIKitHelper

extension UIColor {
    static let theme: UIColor = .dynamicColor(light: .black, dark: .white)
    static let primary: UIColor = .dynamicColor(light: .white, dark: .black)
    static let secondary: UIColor = .dynamicColor(light: .darkGray, dark: .lightGray)
    static let thinGray: UIColor = .lightGray.withAlphaComponent(0.5)
    static let alert: UIColor = .hexCC0000
    static let warning: UIColor = .hexFFD700
    static let sheet: UIColor = .dynamicColor(light: .hexD0D3D4, dark: .hex626567)
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255

        self.init(
            red: r,
            green: g,
            blue: b,
            alpha: alpha
        )
    }
}

private extension UIColor {
    static let hexD0D3D4: UIColor = .init(hex: "D0D3D4")
    static let hex626567: UIColor = .init(hex: "1E1B1A")
    static let hexCC0000: UIColor = .init(hex: "CC0000")
    static let hexFFD700: UIColor = .init(hex: "FFD700")
}
