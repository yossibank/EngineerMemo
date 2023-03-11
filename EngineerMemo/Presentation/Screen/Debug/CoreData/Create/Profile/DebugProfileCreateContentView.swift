#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugProfileCreateContentView: UIView {
        private(set) lazy var didChangeAddressControlPublisher = addressControl.segmentIndexPublisher
        private(set) lazy var didChangeBirthdayControlPublisher = birthdayControl.segmentIndexPublisher
        private(set) lazy var didChangeEmailControlPublisher = emailControl.segmentIndexPublisher
        private(set) lazy var didChangeGenderControlPublisher = genderControl.segmentIndexPublisher
        private(set) lazy var didChangeNameControlPublisher = nameControl.segmentIndexPublisher
        private(set) lazy var didChangePhoneNumberControlPublisher = phoneNumberControl.segmentIndexPublisher
        private(set) lazy var didChangeStationControlPublisher = stationControl.segmentIndexPublisher
        private(set) lazy var didTapCreateButtonPublisher = body.didTapActionButtonPublisher

        private var cancellables: Set<AnyCancellable> = .init()

        private lazy var body = DebugCoreDataSegmentContentView()
            .configure {
                $0.setupContentView(
                    view: VStackView(spacing: 12) {
                        addressControl
                        birthdayControl
                        emailControl
                        genderControl
                        nameControl
                        phoneNumberControl
                        stationControl
                    },
                    type: .create
                )
            }

        private let addressControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.address
        )

        private let birthdayControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.birthday
        )

        private let emailControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.email
        )

        private let genderControl = DebugGenderSegmentView(
            title: L10n.Debug.Segment.gender
        )

        private let nameControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.name
        )

        private let phoneNumberControl = DebugPhoneNumberSegmentView(
            title: L10n.Debug.Segment.phoneNumber
        )

        private let stationControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.station
        )

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - protocol

    extension DebugProfileCreateContentView: ContentView {
        func setupView() {
            backgroundColor = .primary

            addSubview(body) {
                $0.top.leading.trailing.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugProfileCreateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugProfileCreateContentView()
            )
        }
    }
#endif
