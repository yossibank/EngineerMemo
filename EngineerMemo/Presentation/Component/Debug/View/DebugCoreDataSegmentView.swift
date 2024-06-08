#if DEBUG
    import SwiftUI
    import UIKit

    enum DebugCoreDataSegment: Int, CaseIterable {
        case short
        case medium
        case long
        case none

        var title: String {
            switch self {
            case .short: L10n.Debug.Segment.short
            case .medium: L10n.Debug.Segment.medium
            case .long: L10n.Debug.Segment.long
            case .none: .noSetting
            }
        }

        var string: String? {
            switch self {
            case .short: .randomElement(5)
            case .medium: .randomElement(15)
            case .long: .randomElement(50)
            case .none: nil
            }
        }

        var date: Date? {
            switch self {
            case .short: Calendar.date(year: 2022, month: 1, day: 1)
            case .medium: Calendar.date(year: 2000, month: 1, day: 1)
            case .long: Calendar.date(year: 1000, month: 1, day: 1)
            case .none: nil
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
                    $0.verticalEdges.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(16)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugCoreDataSegmentView(title: "title"))
                .frame(height: 40)
        }
    }
#endif
