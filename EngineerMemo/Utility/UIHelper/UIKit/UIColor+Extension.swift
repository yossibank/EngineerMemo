import UIKit
import UIKitHelper

extension UIColor {
    static let background: UIColor = .dynamicColor(light: .hexFFFFFF, dark: .hex181818)
    static let primary: UIColor = .dynamicColor(light: .hex080808, dark: .hexFFFFFF)
    static let primaryGray: UIColor = .dynamicColor(light: .hexCCCCCC, dark: .hex696969)
    static let secondaryGray: UIColor = .dynamicColor(light: .hex696969, dark: .hexD0D0D0)
    static let grayButton: UIColor = .dynamicColor(light: .hexA6A6A6, dark: .hex4A4A4A)
    static let alert: UIColor = .hexCC0000
    static let warning: UIColor = .hexFFD700
    static let sheet: UIColor = .dynamicColor(light: .hexD0D3D4, dark: .hex1E1B1A)
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
    // 白系
    static let hexFFFFFF: UIColor = .init(hex: "FFFFFF")
    // 黒系
    static let hex080808: UIColor = .init(hex: "080808")
    static let hex181818: UIColor = .init(hex: "181818")
    // グレー系
    static let hex1E1B1A: UIColor = .init(hex: "1E1B1A")
    static let hex4A4A4A: UIColor = .init(hex: "4A4A4A")
    static let hex696969: UIColor = .init(hex: "696969")
    static let hexA6A6A6: UIColor = .init(hex: "A6A6A6")
    static let hexCCCCCC: UIColor = .init(hex: "CCCCCC")
    static let hexD0D0D0: UIColor = .init(hex: "D0D0D0")
    static let hexD0D3D4: UIColor = .init(hex: "D0D3D4")
    // 赤色系
    static let hexFFD700: UIColor = .init(hex: "FFD700")
    // 黄色系
    static let hexCC0000: UIColor = .init(hex: "CC0000")
}
