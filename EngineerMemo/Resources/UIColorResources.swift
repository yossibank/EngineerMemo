import UIKit

extension UIColor {
    /// ライトモード: 白(#FFFFFF) ダークモード: 黒(#181818)
    static let background: UIColor = .dynamicColor(light: .hexFFFFFF, dark: .hex181818)
    /// ライトモード: 白(#FFFFFF) ダークモード: 黒(#080808)
    static let theme: UIColor = .dynamicColor(light: .hexFFFFFF, dark: .hex080808)
    /// ライトモード: 黒(#080808) ダークモード: 白(#FFFFFF)
    static let primary: UIColor = .dynamicColor(light: .hex080808, dark: .hexFFFFFF)
    /// ライトモード: グレー(#CCCCCC) ダークモード: グレー(#696969)
    static let primaryGray: UIColor = .dynamicColor(light: .hexCCCCCC, dark: .hex696969)
    /// ライトモード: グレー(#696969) ダークモード: グレー(#D0D0D0)
    static let secondaryGray: UIColor = .dynamicColor(light: .hex696969, dark: .hexD0D0D0)
    /// ライトモード: グレー(#A6A6A6) ダークモード: グレー(#4A4A4A)
    static let grayButton: UIColor = .dynamicColor(light: .hexA6A6A6, dark: .hex4A4A4A)
    /// ライトモード & ダークモード: 赤(#CC0000)
    static let alert: UIColor = .hexCC0000
    /// ライトモード & ダークモード: 黄(#FFD700)
    static let warning: UIColor = .hexFFD700
    /// ライトモード: 白(#EDEDED) ダークモード: グレー(#1C1C1C)
    static let sheet: UIColor = .dynamicColor(light: .hexEDEDED, dark: .hex1C1C1C)
    /// ライトモード & ダークモード: システムグリーン
    static let inputBorder: UIColor = .systemGreen
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

extension UIColor {
    static func dynamicColor(
        light: UIColor,
        dark: UIColor
    ) -> UIColor {
        .init { traitCollection -> UIColor in
            traitCollection.userInterfaceStyle == .light ? light : dark
        }
    }
}

private extension UIColor {
    // 白系
    static let hexFFFFFF: UIColor = .init(hex: "FFFFFF")
    static let hexEDEDED: UIColor = .init(hex: "EDEDED")
    // 黒系
    static let hex080808: UIColor = .init(hex: "080808")
    static let hex181818: UIColor = .init(hex: "181818")
    // グレー系
    static let hex1C1C1C: UIColor = .init(hex: "1C1C1C")
    static let hex4A4A4A: UIColor = .init(hex: "4A4A4A")
    static let hex696969: UIColor = .init(hex: "696969")
    static let hexA6A6A6: UIColor = .init(hex: "A6A6A6")
    static let hexCCCCCC: UIColor = .init(hex: "CCCCCC")
    static let hexD0D0D0: UIColor = .init(hex: "D0D0D0")
    // 赤色系
    static let hexCC0000: UIColor = .init(hex: "CC0000")
    // 黄色系
    static let hexFFD700: UIColor = .init(hex: "FFD700")
    // 青色系
    static let hex00B7CE: UIColor = .init(hex: "00B7CE")
}
