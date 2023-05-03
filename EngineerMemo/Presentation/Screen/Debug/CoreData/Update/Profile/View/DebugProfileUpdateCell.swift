#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugProfileUpdateCell: UITableViewCell {
        var cancellables: Set<AnyCancellable> = .init()

        private(set) lazy var addressControlPublisher = addressControl.segmentIndexPublisher
        private(set) lazy var birthdayControlPublisher = birthdayControl.segmentIndexPublisher
        private(set) lazy var emailControlPublisher = emailControl.segmentIndexPublisher
        private(set) lazy var genderControlPublisher = genderControl.segmentIndexPublisher
        private(set) lazy var iconImageControlPublisher = iconImageControl.segmentIndexPublisher
        private(set) lazy var nameControlPublisher = nameControl.segmentIndexPublisher
        private(set) lazy var phoneNumberControlPublisher = phoneNumberControl.segmentIndexPublisher
        private(set) lazy var stationControlPublisher = stationControl.segmentIndexPublisher
        private(set) lazy var skillControlPublisher = skillControl.segmentIndexPublisher
        private(set) lazy var didTapUpdateButtonPublisher = body.didTapActionButtonPublisher

        private lazy var body = DebugCoreDataSegmentContentView(.update).configure {
            $0.setupContentView(
                view: VStackView(spacing: 12) {
                    addressControl
                    birthdayControl
                    emailControl
                    genderControl
                    iconImageControl
                    nameControl
                    phoneNumberControl
                    stationControl
                    skillControl
                }
            )
        }

        private let addressControl = DebugCoreDataSegmentView(title: L10n.Debug.Segment.address)
        private let birthdayControl = DebugCoreDataSegmentView(title: L10n.Debug.Segment.birthday)
        private let emailControl = DebugCoreDataSegmentView(title: L10n.Debug.Segment.email)
        private let genderControl = DebugGenderSegmentView(title: L10n.Debug.Segment.gender)
        private let iconImageControl = DebugIconImageSegmentView(title: L10n.Debug.Segment.iconImage)
        private let nameControl = DebugCoreDataSegmentView(title: L10n.Debug.Segment.name)
        private let phoneNumberControl = DebugPhoneNumberSegmentView(title: L10n.Debug.Segment.phoneNumber)
        private let stationControl = DebugCoreDataSegmentView(title: L10n.Debug.Segment.station)
        private let skillControl = DebugDefaultSegmentView(title: L10n.Debug.Segment.skill)

        override init(
            style: UITableViewCell.CellStyle,
            reuseIdentifier: String?
        ) {
            super.init(
                style: style,
                reuseIdentifier: reuseIdentifier
            )

            setupView()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override func prepareForReuse() {
            super.prepareForReuse()

            cancellables.removeAll()
        }
    }

    // MARK: - private methods

    private extension DebugProfileUpdateCell {
        func setupView() {
            configure {
                $0.separatorInset = .zero
                $0.selectionStyle = .none
            }

            contentView.configure {
                $0.addSubview(body) {
                    $0.top.bottom.equalToSuperview().inset(16)
                    $0.leading.trailing.equalToSuperview()
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugProfileUpdateCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProfileUpdateCell())
        }
    }
#endif
