#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - menu type

    enum DebugCoreDataMenuType: CaseIterable {
        case profile
        case skill
        case memo

        var title: String {
            switch self {
            case .profile:
                return L10n.Debug.CoreData.profile

            case .skill:
                return L10n.Debug.CoreData.skill

            case .memo:
                return L10n.Debug.CoreData.memo
            }
        }

        var listViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.List.Profile()

            case .skill:
                return AppControllers.Debug.CoreDataObject.List.Skill()

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

            default:
                fatalError(.noSetting)
            }
        }

        var updateViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.Update.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.Update.Memo()

            default:
                fatalError(.noSetting)
            }
        }
    }

    // MARK: - properties & init

    final class DebugCoreDataMenuContentView: UIView {
        @Published private(set) var selectedType: DebugCoreDataMenuType = .profile

        private var menus = DebugCoreDataMenuType.allCases {
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

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                super.traitCollectionDidChange(previousTraitCollection)

                menuButton.layer.borderColor = UIColor.primary.cgColor
            }
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
                menus = DebugCoreDataMenuType.allCases

            case .create, .update:
                menus = [.profile, .memo]
            }

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

            menus.forEach { type in
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
