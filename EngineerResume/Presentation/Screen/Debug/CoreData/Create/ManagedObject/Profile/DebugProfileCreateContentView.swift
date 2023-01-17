#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - stored properties & init

    final class DebugProfileCreateContentView: UIView {
        private(set) lazy var addressControlPublisher = addressControl.segmentIndexPublisher
        private(set) lazy var ageControlPublisher = ageControl.segmentIndexPublisher
        private(set) lazy var emailControlPublisher = emailControl.segmentIndexPublisher
        private(set) lazy var genderControlPublisher = genderControl.segmentIndexPublisher
        private(set) lazy var nameControlPublisher = nameControl.segmentIndexPublisher
        private(set) lazy var phoneNumberControlPublisher = phoneNumberControl.segmentIndexPublisher
        private(set) lazy var stationControlPublisher = stationControl.segmentIndexPublisher
        private(set) lazy var didTapCreateButtonPublisher = createButton.publisher(for: .touchUpInside)

        private lazy var stackView: UIStackView = {
            $0.axis = .vertical
            $0.alignment = .center
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
            createButton
        ]))

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

        private let phoneNumberControl: DebugCoreDataSegmentView = {
            $0.configure(title: L10n.Debug.Segment.phoneNumber)
            return $0
        }(DebugCoreDataSegmentView())

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
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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

            createButton.snp.makeConstraints {
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
