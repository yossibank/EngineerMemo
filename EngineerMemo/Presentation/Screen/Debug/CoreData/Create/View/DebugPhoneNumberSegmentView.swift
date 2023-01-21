#if DEBUG
    import SnapKit
    import SwiftUI
    import UIKit

    enum DebugPhoneNumberSegment: Int, CaseIterable {
        case phone
        case none

        var title: String {
            switch self {
            case .phone: return "携帯番号"
            case .none: return .noSetting
            }
        }

        var phoneNumber: String? {
            switch self {
            case .phone: return "08011112222"
            case .none: return nil
            }
        }

        static var defaultPhoneNumber: String? { phone.phoneNumber }

        static func segment(_ value: Int) -> Self {
            .init(rawValue: value) ?? .none
        }
    }

    // MARK: - stored properties & init

    final class DebugPhoneNumberSegmentView: UIView {
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
            $0.selectedSegmentIndex = DebugPhoneNumberSegment.phone.rawValue
            return $0
        }(UISegmentedControl(items: DebugPhoneNumberSegment.allCases.map(\.title)))

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

    extension DebugPhoneNumberSegmentView {
        func configure(title: String) {
            titleLabel.text = title
        }
    }

    // MARK: - private methods

    private extension DebugPhoneNumberSegmentView {
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

    struct DebugPhoneNumberSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugPhoneNumberSegmentView()
            ) {
                $0.configure(title: "title")
            }
        }
    }
#endif
