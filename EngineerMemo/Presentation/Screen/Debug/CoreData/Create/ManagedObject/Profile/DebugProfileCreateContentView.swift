#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

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
            .addSubview(createButton) {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(160)
                $0.height.equalTo(48)
            }
            .addConstraint {
                $0.height.equalTo(48)
            }

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

        private let createButton = UIButton(type: .system)
            .modifier(\.layer.borderColor, UIColor.theme.cgColor)
            .modifier(\.layer.borderWidth, 1.0)
            .modifier(\.layer.cornerRadius, 8)
            .modifier(\.clipsToBounds, true)
            .configure {
                $0.setTitle(L10n.Components.Button.create, for: .normal)
                $0.setTitleColor(.theme, for: .normal)
            }

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
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
                    self?.createButton.configure {
                        $0.setTitle(L10n.Components.Button.createDone, for: .normal)
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.createButton.configure {
                            $0.setTitle(L10n.Components.Button.create, for: .normal)
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }

    // MARK: - protocol

    extension DebugProfileCreateContentView: ContentView {
        func setupViews() {
            modifier(\.backgroundColor, .primary)

            addSubview(body) {
                $0.edges.equalToSuperview()
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
