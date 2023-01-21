#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - properties & init

    final class DebugProfileUpdateCell: UITableViewCell {
        var cancellables: Set<AnyCancellable> = .init()

        private(set) lazy var addressControlPublisher = addressControl.segmentIndexPublisher
        private(set) lazy var ageControlPublisher = ageControl.segmentIndexPublisher
        private(set) lazy var emailControlPublisher = emailControl.segmentIndexPublisher
        private(set) lazy var genderControlPublisher = genderControl.segmentIndexPublisher
        private(set) lazy var nameControlPublisher = nameControl.segmentIndexPublisher
        private(set) lazy var phoneNumberControlPublisher = phoneNumberControl.segmentIndexPublisher
        private(set) lazy var stationControlPublisher = stationControl.segmentIndexPublisher
        private(set) lazy var didTapUpdateButtonPublisher = updateButton.publisher(for: .touchUpInside)

        private lazy var stackView: UIStackView = {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 12
            $0.setCustomSpacing(32, after: stationControl)
            return $0
        }(UIStackView(arrangedSubviews: [
            addressControl,
            ageControl,
            emailControl,
            genderControl,
            nameControl,
            phoneNumberControl,
            stationControl,
            buttonView
        ]))

        private lazy var buttonView: UIView = {
            $0.addSubview(updateButton)
            return $0
        }(UIView())

        private let addressControl: DebugCoreDataSegmentView = {
            $0.configure(title: L10n.Debug.Segment.address)
            return $0
        }(DebugCoreDataSegmentView())

        private let ageControl: DebugCoreDataSegmentView = {
            $0.configure(title: L10n.Debug.Segment.age)
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
                .ButtonTitle.update,
                .titlePrimary,
                .borderPrimary,
                .cornerRadius8
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
            setupEvents()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }

    // MARK: - private methods

    private extension DebugProfileUpdateCell {
        func setupViews() {
            apply(.backgroundPrimary)
            contentView.addSubview(stackView)
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

        func setupEvents() {
            didTapUpdateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.updateButton.apply(.ButtonTitle.updateDone)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.updateButton.apply(.ButtonTitle.update)
                    }
                }
                .store(in: &cancellables)
        }
    }

    struct DebugProfileUpdateCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProfileUpdateCell())
        }
    }
#endif
