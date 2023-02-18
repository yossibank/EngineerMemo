import UIKit

extension UIColor {
    static let theme: UIColor = .dynamicColor(light: .black, dark: .white)
    static let primary: UIColor = .dynamicColor(light: .white, dark: .black)
    static let secondary: UIColor = .dynamicColor(light: .darkGray, dark: .lightGray)
    static let thinGray: UIColor = .lightGray.withAlphaComponent(0.5)
}
