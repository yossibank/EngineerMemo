#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

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

        private var body: UIView {
            HStackView(spacing: 4) {
                titleLabel
                    .modifier(\.font, .italicSystemFont(ofSize: 14))

                segmentControl
                    .modifier(\.selectedSegmentIndex, DebugPhoneNumberSegment.phone.rawValue)
            }
        }

        private let titleLabel = UILabel()
            .addConstraint {
                $0.width.equalTo(100)
            }

        private let segmentControl = UISegmentedControl(
            items: DebugPhoneNumberSegment.allCases.map(\.title)
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

    private extension DebugPhoneNumberSegmentView {
        func setupViews() {
            modifier(\.backgroundColor, .primary)

            addSubview(body) {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
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
