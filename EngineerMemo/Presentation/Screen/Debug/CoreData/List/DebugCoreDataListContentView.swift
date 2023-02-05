#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit
    import UIStyle

    // MARK: - stored properties & init

    final class DebugCoreDataListContentView: UIView {
        @Published private(set) var selectedType: CoreDataMenuType = .profile

        private let menuButton = UIButton(
            styles: [
                .boldSystemFont(size: 14),
                .borderColor(.theme),
                .borderWidth(1.0),
                .clipsToBounds(true),
                .cornerRadius(8),
                .setTitleColor(.theme)
            ]
        )

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
            setupConstraints()
            setupMenu()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                menuButton.apply(.borderColor(.theme))
            }
        }
    }

    // MARK: - internal methods

    extension DebugCoreDataListContentView {
        func viewUpdate(vc: UIViewController) {
            let containerViewController = selectedType.listViewController

            vc.removeFirstChild()
            vc.add(containerViewController)

            containerViewController.view.snp.makeConstraints {
                $0.top.equalTo(menuButton.snp.bottom).inset(-24)
                $0.bottom.leading.trailing.equalToSuperview()
            }
        }
    }

    // MARK: - private methods

    private extension DebugCoreDataListContentView {
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

            menuButton.apply([
                .menu(.init(
                    title: "",
                    options: .displayInline,
                    children: actions
                )),
                .setTitle(selectedType.title),
                .showsMenuAsPrimaryAction(true)
            ])
        }
    }

    // MARK: - protocol

    extension DebugCoreDataListContentView: ContentView {
        func setupViews() {
            apply([
                .backgroundColor(.primary),
                .addSubview(menuButton)
            ])
        }

        func setupConstraints() {
            menuButton.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(24)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(160)
                $0.height.equalTo(40)
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugCoreDataListContentView()
            )
        }
    }
#endif
