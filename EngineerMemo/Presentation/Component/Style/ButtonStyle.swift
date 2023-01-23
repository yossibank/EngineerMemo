import UIKit

extension Stylable where Self == UIButton {
    init(style: ViewStyle<Self>) {
        self.init(type: .system)
        apply(style)
    }

    init(styles: [ViewStyle<Self>]) {
        self.init(type: .system)
        styles.forEach { apply($0) }
    }
}

extension ViewStyle where T: UIButton {
    // MARK: - 文字タイトル

    enum ButtonTitle {
        static var create: ViewStyle<T> {
            .init {
                $0.setTitle("作成する", for: .normal)
            }
        }

        static var createDone: ViewStyle<T> {
            .init {
                $0.setTitle("作成完了", for: .normal)
            }
        }

        static var update: ViewStyle<T> {
            .init {
                $0.setTitle("更新する", for: .normal)
            }
        }

        static var updateDone: ViewStyle<T> {
            .init {
                $0.setTitle("更新完了", for: .normal)
            }
        }

        static var edit: ViewStyle<T> {
            .init {
                $0.setTitle("編集する", for: .normal)
            }
        }

        static var setting: ViewStyle<T> {
            .init {
                $0.setTitle("設定する", for: .normal)
            }
        }

        static var saveProfile: ViewStyle<T> {
            .init {
                $0.setTitle("プロフィール入力情報を保存する", for: .normal)
            }
        }
    }

    // MARK: - 文字サイズ

    static var system17: ViewStyle<T> {
        .init {
            $0.titleLabel?.font = .systemFont(ofSize: 17)
        }
    }

    static var bold14: ViewStyle<T> {
        .init {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        }
    }

    // MARK: - 文字色

    static var titlePrimary: ViewStyle<T> {
        .init {
            $0.setTitleColor(
                .dynamicColor(light: .black, dark: .white),
                for: .normal
            )
        }
    }

    static var titleTheme: ViewStyle<T> {
        .init {
            $0.setTitleColor(
                .dynamicColor(light: .white, dark: .black),
                for: .normal
            )
        }
    }

    static var titleWhite: ViewStyle<T> {
        .init {
            $0.setTitleColor(
                .white,
                for: .normal
            )
        }
    }

    // MARK: - 文字位置

    static var titleLeft: ViewStyle<T> {
        .init {
            $0.contentHorizontalAlignment = .leading
        }
    }
}
