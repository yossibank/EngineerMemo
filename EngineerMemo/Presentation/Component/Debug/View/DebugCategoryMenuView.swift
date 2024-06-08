#if DEBUG
    import Combine
    import SwiftUI
    import UIKit

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
            case .todo: L10n.Debug.Menu.todo
            case .technical: L10n.Debug.Menu.technical
            case .interview: L10n.Debug.Menu.interview
            case .event: L10n.Debug.Menu.event
            case .tax: L10n.Debug.Menu.tax
            case .other: L10n.Debug.Menu.other
            case .none: .noSetting
            }
        }

        var image: UIImage? {
            switch self {
            case .todo: Asset.toDoCategory.image
            case .technical: Asset.technicalCategory.image
            case .interview: Asset.interviewCategory.image
            case .event: Asset.eventCategory.image
            case .tax: Asset.taxCategory.image
            case .other: Asset.otherCategory.image
            case .none: nil
            }
        }

        var category: MemoModelObject.Category? {
            switch self {
            case .todo: .todo
            case .technical: .technical
            case .interview: .interview
            case .event: .event
            case .tax: .tax
            case .other: .other
            case .none: nil
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

            for category in categories {
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
                .frame(width: 80, height: 40)
        }
    }
#endif
