import UIKit

extension ViewStyle where T: UIView {
    // MARK: - 背景

    static var backgroundPrimary: ViewStyle<T> {
        .init {
            $0.backgroundColor = .dynamicColor(light: .white, dark: .black)
        }
    }

    static var backgroundTheme: ViewStyle<T> {
        .init {
            $0.backgroundColor = .dynamicColor(light: .black, dark: .white)
        }
    }

    static var backgroundGray: ViewStyle<T> {
        .init {
            $0.backgroundColor = .gray
        }
    }

    static var backgroundLightGray: ViewStyle<T> {
        .init {
            $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
        }
    }

    // MARK: - 角丸

    static var cornerRadius8: ViewStyle<T> {
        .init {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
    }

    // MARK: - 枠線色

    static var borderPrimary: ViewStyle<T> {
        .init {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.dynamicColor(light: .black, dark: .white).cgColor
        }
    }
}
