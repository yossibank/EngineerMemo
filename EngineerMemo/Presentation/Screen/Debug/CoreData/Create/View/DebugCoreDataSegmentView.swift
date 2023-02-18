#if DEBUG
    import SnapKit
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
            case .short: return String.randomElement(5)
            case .medium: return String.randomElement(15)
            case .long: return String.randomElement(50)
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

        static var defaultString: String? { medium.string }
        static var defaultDate: Date? { medium.date }

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - properties & init

    final class DebugCoreDataSegmentView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private var body: UIView {
            HStackView(spacing: 4) {
                titleLabel
                    .modifier(\.font, .italicSystemFont(ofSize: 14))

                segmentControl
                    .modifier(\.selectedSegmentIndex, DebugCoreDataSegment.medium.rawValue)
            }
        }

        private let titleLabel = UILabel()
            .configure {
                $0.snp.makeConstraints {
                    $0.width.equalTo(100)
                }
            }

        private let segmentControl = UISegmentedControl(
            items: DebugCoreDataSegment.allCases.map(\.title)
        )

        init(title: String) {
            super.init(frame: .zero)

            setupViews()

            titleLabel.modifier(\.text, title)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugCoreDataSegmentView {
        func setupViews() {
            modifier(\.backgroundColor, .primary)

            addSubview(body) {
                $0.snp.makeConstraints {
                    $0.top.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(16)
                }
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugCoreDataSegmentView(
                    title: "title"
                )
            )
        }
    }
#endif
