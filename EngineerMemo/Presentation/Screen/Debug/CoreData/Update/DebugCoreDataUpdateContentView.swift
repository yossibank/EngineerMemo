#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - stored properties & init

    final class DebugCoreDataUpdateContentView: UIView {
        @Published private(set) var selectedType: CoreDataMenuType = .profile

        private let menuButton = UIButton(
            styles: [
                .bold14,
                .titlePrimary,
                .borderPrimary,
                .cornerRadius8
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

                menuButton.apply(.borderPrimary)
            }
        }
    }

    // MARK: - internal methods

    extension DebugCoreDataUpdateContentView {
        func viewUpdate(vc: UIViewController) {
            let containerViewController = selectedType.updateViewController

            vc.removeFirstChild()
            vc.add(containerViewController)

            containerViewController.view.snp.makeConstraints {
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

            menuButton.menu = .init(
                title: "",
                options: .displayInline,
                children: actions
            )
            menuButton.showsMenuAsPrimaryAction = true
            menuButton.setTitle(selectedType.title, for: .normal)
        }
    }

    // MARK: - protocol

    extension DebugCoreDataUpdateContentView: ContentView {
        func setupViews() {
            apply(.backgroundPrimary)
            addSubview(menuButton)
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

    struct DebugCoreDataUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugCoreDataUpdateContentView()
            )
        }
    }
#endif
