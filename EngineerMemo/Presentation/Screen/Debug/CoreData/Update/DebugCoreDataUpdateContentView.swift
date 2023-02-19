#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugCoreDataUpdateContentView: UIView {
        @Published private(set) var selectedType: CoreDataMenuType = .profile

        private let menuButton = UIButton(type: .system)
            .modifier(\.layer.borderColor, UIColor.theme.cgColor)
            .modifier(\.layer.borderWidth, 1.0)
            .modifier(\.layer.cornerRadius, 8)
            .modifier(\.clipsToBounds, true)
            .configure {
                $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
                $0.setTitleColor(.theme, for: .normal)
            }

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupMenu()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                menuButton.modifier(\.layer.borderColor, .theme)
            }
        }
    }

    // MARK: - internal methods

    extension DebugCoreDataUpdateContentView {
        func viewUpdate(vc: UIViewController) {
            let containerViewController = selectedType.updateViewController

            vc.removeFirstChild()
            vc.addSubviewController(containerViewController)

            containerViewController.view.addConstraint {
                $0.top.equalTo(menuButton.snp.bottom).inset(-24)
                $0.bottom.leading.trailing.equalToSuperview()
            }
        }
    }

    // MARK: - private methods

    private extension DebugCoreDataUpdateContentView {
        func setupMenu() {
            var actions = [UIMenuElement]()

            CoreDataMenuType.allCases.forEach { type in
                actions.append(
                    UIAction(
                        title: type.title,
                        state: type == selectedType ? .on : .off,
                        handler: { [weak self] _ in
                            self?.selectedType = type
                            self?.setupMenu()
                        }
                    )
                )
            }

            menuButton.configure {
                $0.menu = .init(
                    title: "",
                    options: .displayInline,
                    children: actions
                )
                $0.setTitle(selectedType.title, for: .normal)
                $0.showsMenuAsPrimaryAction = true
            }
        }
    }

    // MARK: - protocol

    extension DebugCoreDataUpdateContentView: ContentView {
        func setupView() {
            modifier(\.backgroundColor, .primary)

            addSubview(menuButton) {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(24)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(160)
                $0.height.equalTo(40)
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugCoreDataUpdateContentView()
            )
        }
    }
#endif
