import UIKit

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
