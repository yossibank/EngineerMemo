#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit
    import UIStyle

    // MARK: - properties & init

    final class DebugProfileCreateContentView: UIView {
        private(set) lazy var addressControlPublisher = addressControl.segmentIndexPublisher
        private(set) lazy var birthdayControlPublisher = birthdayControl.segmentIndexPublisher
        private(set) lazy var emailControlPublisher = emailControl.segmentIndexPublisher
        private(set) lazy var genderControlPublisher = genderControl.segmentIndexPublisher
        private(set) lazy var nameControlPublisher = nameControl.segmentIndexPublisher
        private(set) lazy var phoneNumberControlPublisher = phoneNumberControl.segmentIndexPublisher
        private(set) lazy var stationControlPublisher = stationControl.segmentIndexPublisher
        private(set) lazy var didTapCreateButtonPublisher = createButton.publisher(for: .touchUpInside)

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
            style: .addSubview(createButton)
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

        private var cancellables: Set<AnyCancellable> = .init()

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

        private let createButton = UIButton(
            styles: [
                .borderColor(.theme),
                .borderWidth(1.0),
                .clipsToBounds(true),
                .cornerRadius(8),
                .setTitle(L10n.Components.Button.create),
                .setTitleColor(.theme)
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
                    self?.createButton.apply(.setTitle(L10n.Components.Button.createDone))

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.createButton.apply(.setTitle(L10n.Components.Button.create))
                    }
                }
                .store(in: &cancellables)
        }
    }

    // MARK: - protocol

    extension DebugProfileCreateContentView: ContentView {
        func setupViews() {
            apply([
                .addSubview(stackView),
                .backgroundColor(.primary)
            ])
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
