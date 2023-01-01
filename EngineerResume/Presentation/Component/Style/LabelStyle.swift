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

    static var heavy18: ViewStyle<T> {
        .init {
            $0.font = .systemFont(ofSize: 18, weight: .heavy)
        }
    }

    // MARK: - 文字色

    static var red: ViewStyle<T> {
        .init {
            $0.textColor = .red
        }
    }

    static var lightGray: ViewStyle<T> {
        .init {
            $0.textColor = .lightGray
        }
    }

    // MARK: 最大行

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
