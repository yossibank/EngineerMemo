#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugCoreDataMenuContentView: UIView {
        @Published private(set) var selectedMenuType: DebugCoreDataMenuType = .profile

        private var menuTypes = DebugCoreDataMenuType.allCases {
            didSet {
                setupMenu()
            }
        }

        private let menuButton = UIButton(type: .system)
            .apply(.debugMenuButton)

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupMenu()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - internal methods

    extension DebugCoreDataMenuContentView {
        func viewUpdate(
            vc: UIViewController,
            displayType: DebugCoreDataDisplayType
        ) {
            switch displayType {
            case .list:
                menuTypes = DebugCoreDataMenuType.allCases

            case .create, .update:
                menuTypes = [.profile, .memo]
            }

            let containerViewController: UIViewController = {
                switch displayType {
                case .list:
                    return selectedMenuType.listViewController

                case .create:
                    return selectedMenuType.createViewController

                case .update:
                    return selectedMenuType.updateViewController
                }
            }()

            vc.removeFirstChild()
            vc.addSubviewController(containerViewController)

            containerViewController.view.addConstraint {
                $0.top.equalTo(menuButton.snp.bottom).inset(-24)
                $0.bottom.leading.trailing.equalToSuperview()
            }
        }
    }

    // MARK: - private methods

    private extension DebugCoreDataMenuContentView {
        func setupMenu() {
            var actions = [UIMenuElement]()

            menuTypes.forEach { menuType in
                actions.append(
                    UIAction(
                        title: menuType.title,
                        state: menuType == selectedMenuType ? .on : .off,
                        handler: { [weak self] _ in
                            self?.selectedMenuType = menuType
                            self?.setupMenu()
                        }
                    )
                )
            }

            menuButton.configure {
                $0.menu = .init(
                    title: .empty,
                    options: .displayInline,
                    children: actions
                )
                $0.setTitle(selectedMenuType.title, for: .normal)
                $0.showsMenuAsPrimaryAction = true
            }
        }
    }

    // MARK: - protocol

    extension DebugCoreDataMenuContentView: ContentView {
        func setupView() {
            configure {
                $0.addSubview(menuButton) {
                    $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(24)
                    $0.centerX.equalToSuperview()
                    $0.width.equalTo(160)
                    $0.height.equalTo(40)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataMenuContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugCoreDataMenuContentView())
        }
    }
#endif
