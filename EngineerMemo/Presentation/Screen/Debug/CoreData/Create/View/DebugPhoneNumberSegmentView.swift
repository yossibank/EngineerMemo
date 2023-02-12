#if DEBUG
    import SnapKit
    import SwiftUI
    import UIKit
    import UIStyle

    enum DebugPhoneNumberSegment: Int, CaseIterable {
        case phone
        case none

        var title: String {
            switch self {
            case .phone: return L10n.Debug.Segment.tellNumber
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

    // MARK: - properties & init

    final class DebugPhoneNumberSegmentView: UIView {
        private(set) lazy var segmentIndexPublisher = segmentControl.selectedIndexPublisher

        private lazy var stackView = UIStackView(
            styles: [
                .addArrangedSubviews(arrangedSubviews),
                .axis(.horizontal),
                .spacing(4)
            ]
        )

        private lazy var arrangedSubviews = [
            titleLabel,
            segmentControl
        ]

        private let titleLabel = UILabel(
            style: .italicSystemFont(size: 14)
        )

        private let segmentControl = UISegmentedControl(
            style: .selectedSegmentIndex(DebugPhoneNumberSegment.phone.rawValue),
            items: DebugPhoneNumberSegment.allCases.map(\.title)
        )

        init(title: String) {
            super.init(frame: .zero)

            setupViews()
            setupConstraints()

            titleLabel.apply(.text(title))
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugPhoneNumberSegmentView {
        func setupViews() {
            apply([
                .backgroundColor(.primary),
                .addSubview(stackView)
            ])
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
                view: DebugPhoneNumberSegmentView(
                    title: "title"
                )
            )
        }
    }
#endif
