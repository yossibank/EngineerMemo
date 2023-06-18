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
        typealias Segment = DebugPhoneNumberSegment

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
                    $0.selectedSegmentIndex = Segment.phone.rawValue
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

    private extension DebugPhoneNumberSegmentView {
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

    struct DebugPhoneNumberSegmentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugPhoneNumberSegmentView(title: "title"))
        }
    }
#endif
