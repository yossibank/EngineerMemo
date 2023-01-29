#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit
    import UIStyle

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

        private lazy var stackView = UIStackView(
            styles: [
                .addArrangedSubviews(arrangedSubviews),
                .alignment(.fill),
                .axis(.vertical),
                .setCustomSpacing(32, after: stationControl),
                .spacing(12)
            ]
        )

        private lazy var buttonView = UIView(
            style: .addSubview(updateButton)
        )

        private lazy var arrangedSubviews = [
            addressControl,
            birthdayControl,
            emailControl,
            genderControl,
            nameControl,
            phoneNumberControl,
            stationControl,
            buttonView
        ]

        private let addressControl: DebugCoreDataSegmentView = {
            $0.configure(title: L10n.Debug.Segment.address)
            return $0
        }(DebugCoreDataSegmentView())

        private let birthdayControl: DebugCoreDataSegmentView = {
            $0.configure(title: L10n.Debug.Segment.birthday)
            return $0
        }(DebugCoreDataSegmentView())

        private let emailControl: DebugCoreDataSegmentView = {
            $0.configure(title: L10n.Debug.Segment.email)
            return $0
        }(DebugCoreDataSegmentView())

        private let genderControl: DebugGenderSegmentView = {
            $0.configure(title: L10n.Debug.Segment.gender)
            return $0
        }(DebugGenderSegmentView())

        private let nameControl: DebugCoreDataSegmentView = {
            $0.configure(title: L10n.Debug.Segment.name)
            return $0
        }(DebugCoreDataSegmentView())

        private let phoneNumberControl: DebugPhoneNumberSegmentView = {
            $0.configure(title: L10n.Debug.Segment.phoneNumber)
            return $0
        }(DebugPhoneNumberSegmentView())

        private let stationControl: DebugCoreDataSegmentView = {
            $0.configure(title: L10n.Debug.Segment.station)
            return $0
        }(DebugCoreDataSegmentView())

        private let updateButton = UIButton(
            styles: [
                .borderColor(.theme),
                .borderWidth(1.0),
                .clipsToBounds(true),
                .cornerRadius(8),
                .setTitle(L10n.Components.Button.update),
                .setTitleColor(.theme)
            ]
        )

        override init(
            style: UITableViewCell.CellStyle,
            reuseIdentifier: String?
        ) {
            super.init(
                style: style,
                reuseIdentifier: reuseIdentifier
            )

            setupViews()
            setupConstraints()
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
            updateButton.apply(.setTitle(L10n.Components.Button.updateDone))

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateButton.apply(.setTitle(L10n.Components.Button.update))
            }
        }
    }

    // MARK: - private methods

    private extension DebugProfileUpdateCell {
        func setupViews() {
            apply([
                .addSubview(stackView),
                .backgroundColor(.primary)
            ])
        }

        func setupConstraints() {
            stackView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(16)
                $0.leading.trailing.equalToSuperview()
            }

            buttonView.snp.makeConstraints {
                $0.height.equalTo(48)
            }

            updateButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(160)
                $0.height.equalTo(48)
            }
        }
    }

    struct DebugProfileUpdateCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProfileUpdateCell())
        }
    }
#endif
