#if DEBUG
    import SnapKit
    import SwiftUI
    import UIKit

    enum DebugCoreDataSegment: Int, CaseIterable {
        case short = 0
        case medium
        case long
        case none

        var title: String {
            switch self {
            case .short: return "短め"
            case .medium: return "普通"
            case .long: return "長め"
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

    // MARK: - stored properties & init

    final class DebugCoreDataSegmentView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private lazy var stackView: UIStackView = {
            $0.axis = .horizontal
            $0.spacing = 4
            return $0
        }(UIStackView(arrangedSubviews: [
            titleLabel,
            segmentControl
        ]))

        private let titleLabel = UILabel(style: .italic14)

        private let segmentControl: UISegmentedControl = {
            $0.selectedSegmentIndex = DebugCoreDataSegment.medium.rawValue
            return $0
        }(UISegmentedControl(items: DebugCoreDataSegment.allCases.map(\.title)))

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
            setupConstraints()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - internal methods

    extension DebugCoreDataSegmentView {
        func configure(title: String) {
            titleLabel.text = title
        }
    }

    // MARK: - private methods

    private extension DebugCoreDataSegmentView {
        func setupViews() {
            apply(.backgroundPrimary)
            addSubview(stackView)
        }

        func setupConstraints() {
            stackView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            titleLabel.snp.makeConstraints {
                $0.width.equalTo(100)
            }
        }
    }

    // MARK: - preview

    struct DebugCoreDataSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugCoreDataSegmentView()
            ) {
                $0.configure(title: "title")
            }
        }
    }
#endif