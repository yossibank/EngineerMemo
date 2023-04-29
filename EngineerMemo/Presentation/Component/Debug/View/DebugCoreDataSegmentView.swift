#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    enum DebugCoreDataSegment: Int, CaseIterable {
        case short = 0
        case medium
        case long
        case none

        var title: String {
            switch self {
            case .short: return L10n.Debug.Segment.short
            case .medium: return L10n.Debug.Segment.medium
            case .long: return L10n.Debug.Segment.long
            case .none: return .noSetting
            }
        }

        var string: String? {
            switch self {
            case .short: return .randomElement(5)
            case .medium: return .randomElement(15)
            case .long: return .randomElement(50)
            case .none: return nil
            }
        }

        var date: Date? {
            switch self {
            case .short: return Calendar.date(year: 2022, month: 1, day: 1)
            case .medium: return Calendar.date(year: 2000, month: 1, day: 1)
            case .long: return Calendar.date(year: 1000, month: 1, day: 1)
            case .none: return nil
            }
        }

        var skill: SkillModelObject? {
            switch self {
            case .short: return SKillModelObjectBuilder().build()
            case .medium: return SKillModelObjectBuilder().build()
            case .long: return SKillModelObjectBuilder().build()
            case .none: return nil
            }
        }

        static var defaultString: String? { medium.string }
        static var defaultDate: Date? { medium.date }
        static var defaultSkill: SkillModelObject? { medium.skill }

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - properties & init

    final class DebugCoreDataSegmentView: UIView {
        typealias Segment = DebugCoreDataSegment

        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            HStackView(spacing: 4) {
                titleLabel
                    .addConstraint {
                        $0.width.equalTo(100)
                    }
                    .configure {
                        $0.font = .italicSystemFont(ofSize: 14)
                    }

                segmentControl.configure {
                    $0.selectedSegmentIndex = Segment.medium.rawValue
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

    private extension DebugCoreDataSegmentView {
        func setupView() {
            configure {
                $0.addSubview(body) {
                    $0.top.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(16)
                }

                $0.backgroundColor = .primary
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugCoreDataSegmentView(title: "title"))
        }
    }
#endif
