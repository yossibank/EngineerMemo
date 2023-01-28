#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - stored properties & init

    final class DebugProfileCreateContentView: UIView {
        private(set) lazy var addressControlPublisher = addressControl.segmentIndexPublisher
        private(set) lazy var birthdayControlPublisher = birthdayControl.segmentIndexPublisher
        private(set) lazy var emailControlPublisher = emailControl.segmentIndexPublisher
        private(set) lazy var genderControlPublisher = genderControl.segmentIndexPublisher
        private(set) lazy var nameControlPublisher = nameControl.segmentIndexPublisher
        private(set) lazy var phoneNumberControlPublisher = phoneNumberControl.segmentIndexPublisher
        private(set) lazy var stationControlPublisher = stationControl.segmentIndexPublisher
        private(set) lazy var didTapCreateButtonPublisher = createButton.publisher(for: .touchUpInside)

        private lazy var stackView: UIStackView = {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 12
            $0.setCustomSpacing(32, after: stationControl)
            return $0
        }(UIStackView(arrangedSubviews: [
            addressControl,
            birthdayControl,
            emailControl,
            genderControl,
            nameControl,
            phoneNumberControl,
            stationControl,
            buttonView
        ]))

        private lazy var buttonView: UIView = {
            $0.addSubview(createButton)
            return $0
        }(UIView())

        private var cancellables: Set<AnyCancellable> = .init()

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

        private let createButton = UIButton(
            styles: [
                .ButtonTitle.create,
                .titlePrimary,
                .borderPrimary,
                .cornerRadius8
            ]
        )

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
            setupConstraints()
            setupEvents()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugProfileCreateContentView {
        func setupEvents() {
            didTapCreateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.createButton.apply(.ButtonTitle.createDone)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.createButton.apply(.ButtonTitle.create)
                    }
                }
                .store(in: &cancellables)
        }
    }

    // MARK: - protocol

    extension DebugProfileCreateContentView: ContentView {
        func setupViews() {
            apply(.backgroundPrimary)
            addSubview(stackView)
        }

        func setupConstraints() {
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }

            buttonView.snp.makeConstraints {
                $0.height.equalTo(48)
            }

            createButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(160)
                $0.height.equalTo(48)
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
