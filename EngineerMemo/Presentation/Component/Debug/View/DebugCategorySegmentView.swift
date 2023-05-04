#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    enum DebugCategorySegment: Int, CaseIterable {
        case todo
        case technical
        case interview
        case event
        case other
        case none

        var title: String {
            switch self {
            case .todo: return L10n.Debug.Segment.todo
            case .technical: return L10n.Debug.Segment.technical
            case .interview: return L10n.Debug.Segment.interview
            case .event: return L10n.Debug.Segment.event
            case .other: return L10n.Debug.Segment.other
            case .none: return .noSetting
            }
        }

        var category: MemoModelObject.Category? {
            switch self {
            case .todo: return .todo
            case .technical: return .technical
            case .interview: return .interview
            case .event: return .event
            case .other: return .other
            case .none: return nil
            }
        }

        static var defaultCategory: MemoModelObject.Category = .technical

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - properties & init

    final class DebugCategorySegmentView: UIView {
        typealias Segment = DebugCategorySegment

        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            HStackView(spacing: 4) {
                titleLabel
                    .addConstraint {
                        $0.width.equalTo(60)
                    }
                    .configure {
                        $0.font = .italicSystemFont(ofSize: 14)
                    }

                segmentControl.configure {
                    $0.setTitleTextAttributes(
                        [.font: UIFont.systemFont(ofSize: 10)],
                        for: .normal
                    )
                    $0.selectedSegmentIndex = Segment.technical.rawValue
                }
            }
        }

        private let titleLabel = UILabel()
        private let segmentControl = UISegmentedControl(items: Segment.allCases.map(\.title))

        init(title: String) {
            super.init(frame: .zero)

            setupView()

            titleLabel.text = title
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugCategorySegmentView {
        func setupView() {
            configure {
                $0.addSubview(body) {
                    $0.top.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(16)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugCategorySegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugCategorySegmentView(title: "title"))
        }
    }
#endif
