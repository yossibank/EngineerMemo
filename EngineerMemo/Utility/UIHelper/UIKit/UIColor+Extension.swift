import UIKit

extension UIColor {
    static let theme: UIColor = .dynamicColor(light: .black, dark: .white)
    static let primary: UIColor = .dynamicColor(light: .white, dark: .black)
    static let secondary: UIColor = .dynamicColor(light: .darkGray, dark: .lightGray)
    static let thinGray: UIColor = .lightGray.withAlphaComponent(0.5)

    static func dynamicColor(
        light: UIColor,
        dark: UIColor
    ) -> UIColor {
        .init { traitCollection -> UIColor in
            traitCollection.userInterfaceStyle == .light ? light : dark
        }
    }
}
