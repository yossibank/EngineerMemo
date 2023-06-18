#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    enum DebugCategoryMenu: Int, CaseIterable {
        case todo
        case technical
        case interview
        case event
        case tax
        case other
        case none

        var title: String {
            switch self {
            case .todo: return L10n.Debug.Menu.todo
            case .technical: return L10n.Debug.Menu.technical
            case .interview: return L10n.Debug.Menu.interview
            case .event: return L10n.Debug.Menu.event
            case .tax: return L10n.Debug.Menu.tax
            case .other: return L10n.Debug.Menu.other
            case .none: return .noSetting
            }
        }

        var image: UIImage? {
            switch self {
            case .todo: return Asset.toDoCategory.image
            case .technical: return Asset.technicalCategory.image
            case .interview: return Asset.interviewCategory.image
            case .event: return Asset.eventCategory.image
            case .tax: return Asset.taxCategory.image
            case .other: return Asset.otherCategory.image
            case .none: return nil
            }
        }

        var category: MemoModelObject.Category? {
            switch self {
            case .todo: return .todo
            case .technical: return .technical
            case .interview: return .interview
            case .event: return .event
            case .tax: return .tax
            case .other: return .other
            case .none: return nil
            }
        }

        static var defaultCategory: MemoModelObject.Category = .technical
    }

    // MARK: - properties & init

    final class DebugCategoryMenuView: UIView {
        @Published private(set) var selectedCategory: DebugCategoryMenu = .technical

        private var categories = DebugCategoryMenu.allCases {
            didSet {
                setupMenu()
            }
        }

        private var body: UIView {
            HStackView(spacing: 4) {
                titleLabel
                    .addConstraint {
                        $0.width.equalTo(100)
                    }
                    .configure {
                        $0.font = .italicSystemFont(ofSize: 14)
                    }

                menuButton.addConstraint {
                    $0.height.equalTo(40)
                }
            }
        }

        private let titleLabel = UILabel()
        private let menuButton = UIButton(type: .system)

        init(title: String) {
            super.init(frame: .zero)

            setupView()
            setupMenu()

            titleLabel.text = title
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugCategoryMenuView {
        func setupView() {
            configure {
                $0.addSubview(body) {
                    $0.verticalEdges.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(16)
                }

                $0.backgroundColor = .background
            }
        }

        func setupMenu() {
            var actions = [UIMenuElement]()

            categories.forEach { category in
                actions.append(
                    UIAction(
                        title: category.title,
                        state: category == selectedCategory ? .on : .off,
                        handler: { [weak self] _ in
                            self?.selectedCategory = category
                            self?.setupMenu()
                        }
                    )
                )
            }

            menuButton.configure {
                var config = UIButton.Configuration.filled()
                config.title = selectedCategory.title
                config.image = selectedCategory.image?
                    .resized(size: .init(width: 24, height: 24))
                    .withRenderingMode(.alwaysOriginal)
                config.titleTextAttributesTransformer = .init { incoming in
                    var outgoing = incoming
                    outgoing.font = .boldSystemFont(ofSize: 16)
                    return outgoing
                }
                config.baseForegroundColor = .primary
                config.imagePadding = 8
                config.background.backgroundColor = .background
                config.background.cornerRadius = 4
                config.background.strokeColor = .primary
                config.background.strokeWidth = 1.0

                $0.configuration = config
                $0.showsMenuAsPrimaryAction = true
                $0.menu = .init(
                    title: .empty,
                    options: .displayInline,
                    children: actions
                )
            }
        }
    }

    // MARK: - preview

    struct DebugCategoryMenuViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugCategoryMenuView(title: "title"))
        }
    }
#endif
