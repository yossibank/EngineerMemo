#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - menu type

    enum DebugCoreDataMenuType: CaseIterable {
        case profile
        case memo

        var title: String {
            switch self {
            case .profile:
                return L10n.Debug.CoreData.profile

            case .memo:
                return L10n.Debug.CoreData.memo
            }
        }

        var listViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.List.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.List.Memo()
            }
        }

        var createViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.Create.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.Create.Memo()
            }
        }

        var updateViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.Update.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.Update.Memo()
            }
        }
    }

    // MARK: - properties & init

    final class DebugCoreDataMenuContentView: UIView {
        @Published private(set) var selectedType: DebugCoreDataMenuType = .profile

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

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                menuButton.layer.borderColor = UIColor.theme.cgColor
            }
        }
    }

    // MARK: - internal methods

    extension DebugCoreDataMenuContentView {
        func viewUpdate(
            vc: UIViewController,
            displayType: DebugCoreDataDisplayType
        ) {
            let containerViewController: UIViewController = {
                switch displayType {
                case .list:
                    return selectedType.listViewController

                case .create:
                    return selectedType.createViewController

                case .update:
                    return selectedType.updateViewController
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

            DebugCoreDataMenuType.allCases.forEach { type in
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
                    title: .empty,
                    options: .displayInline,
                    children: actions
                )
                $0.setTitle(selectedType.title, for: .normal)
                $0.showsMenuAsPrimaryAction = true
            }
        }
    }

    // MARK: - protocol

    extension DebugCoreDataMenuContentView: ContentView {
        func setupView() {
            configure {
                $0.backgroundColor = .primary
            }

            addSubview(menuButton) {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(24)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(160)
                $0.height.equalTo(40)
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataMenuContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugCoreDataMenuContentView()
            )
        }
    }
#endif
