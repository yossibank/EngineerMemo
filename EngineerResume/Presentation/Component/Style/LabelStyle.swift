import UIKit

extension ViewStyle where T: UILabel {
    // MARK: - 文字サイズ

    static var system8: ViewStyle<T> {
        .init {
            $0.font = .systemFont(ofSize: 8)
        }
    }

    static var system10: ViewStyle<T> {
        .init {
            $0.font = .systemFont(ofSize: 10)
        }
    }

    static var system12: ViewStyle<T> {
        .init {
            $0.font = .systemFont(ofSize: 12)
        }
    }

    static var system14: ViewStyle<T> {
        .init {
            $0.font = .systemFont(ofSize: 14)
        }
    }

    static var italic16: ViewStyle<T> {
        .init {
            $0.font = .italicSystemFont(ofSize: 16)
        }
    }

    static var bold14: ViewStyle<T> {
        .init {
            $0.font = .boldSystemFont(ofSize: 14)
        }
    }

    static var bold16: ViewStyle<T> {
        .init {
            $0.font = .boldSystemFont(ofSize: 16)
        }
    }

    static var heavy18: ViewStyle<T> {
        .init {
            $0.font = .systemFont(ofSize: 18, weight: .heavy)
        }
    }

    // MARK: - 文字色

    static var textPrimary: ViewStyle<T> {
        .init {
            $0.textColor = .dynamicColor(light: .white, dark: .black)
        }
    }

    static var textSecondary: ViewStyle<T> {
        .init {
            $0.textColor = .dynamicColor(light: .darkGray, dark: .lightGray)
        }
    }

    static var textRed: ViewStyle<T> {
        .init {
            $0.textColor = .red
        }
    }

    static var textLightGray: ViewStyle<T> {
        .init {
            $0.textColor = .lightGray
        }
    }

    // MARK: - 文字位置

    static var textLeft: ViewStyle<T> {
        .init {
            $0.textAlignment = .left
        }
    }

    static var textCenter: ViewStyle<T> {
        .init {
            $0.textAlignment = .center
        }
    }

    static var textRight: ViewStyle<T> {
        .init {
            $0.textAlignment = .right
        }
    }

    // MARK: - 最大行

    static var lineInfinity: ViewStyle<T> {
        .init {
            $0.numberOfLines = 0
        }
    }

    static var line1: ViewStyle<T> {
        .init {
            $0.numberOfLines = 1
        }
    }

    static var line2: ViewStyle<T> {
        .init {
            $0.numberOfLines = 2
        }
    }
}
