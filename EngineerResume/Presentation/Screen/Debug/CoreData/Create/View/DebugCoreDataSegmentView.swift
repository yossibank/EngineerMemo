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
            case .short:
                return "短め"

            case .medium:
                return "普通"

            case .long:
                return "長め"

            case .none:
                return "未設定"
            }
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
                $0.height.equalTo(40)
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
