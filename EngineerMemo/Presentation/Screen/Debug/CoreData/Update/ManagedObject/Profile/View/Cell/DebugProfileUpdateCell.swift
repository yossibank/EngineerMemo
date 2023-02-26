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
        private(set) lazy var nameControlPublisher = nameControl.segmentIndexPublisher
        private(set) lazy var phoneNumberControlPublisher = phoneNumberControl.segmentIndexPublisher
        private(set) lazy var stationControlPublisher = stationControl.segmentIndexPublisher
        private(set) lazy var didTapUpdateButtonPublisher = updateButton.publisher(for: .touchUpInside)

        private var body: UIView {
            VStackView(spacing: 12) {
                addressControl
                birthdayControl
                emailControl
                genderControl
                nameControl
                phoneNumberControl
                stationControl
                buttonView
            }
            .configure {
                $0.setCustomSpacing(32, after: stationControl)
            }
        }

        private lazy var buttonView = UIView()
            .addSubview(updateButton) {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(160)
                $0.height.equalTo(48)
            }
            .addConstraint {
                $0.height.equalTo(48)
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

        private let updateButton = UIButton(type: .system)
            .modifier(\.layer.borderColor, UIColor.theme.cgColor)
            .modifier(\.layer.borderWidth, 1.0)
            .modifier(\.layer.cornerRadius, 8)
            .modifier(\.clipsToBounds, true)
            .configure {
                $0.setTitle(L10n.Components.Button.update, for: .normal)
                $0.setTitleColor(.theme, for: .normal)
            }

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

    // MARK: - internal methods

    extension DebugProfileUpdateCell {
        func updateView() {
            updateButton.setTitle(
                L10n.Components.Button.updateDone,
                for: .normal
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateButton.setTitle(
                    L10n.Components.Button.update,
                    for: .normal
                )
            }
        }
    }

    // MARK: - private methods

    private extension DebugProfileUpdateCell {
        func setupView() {
            contentView.backgroundColor = .primary
            selectionStyle = .none

            contentView.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(16)
                $0.leading.trailing.equalToSuperview()
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
