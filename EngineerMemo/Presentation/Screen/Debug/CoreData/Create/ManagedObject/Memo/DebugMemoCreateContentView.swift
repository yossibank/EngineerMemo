#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugMemoCreateContentView: UIView {
        private(set) lazy var titleControlPublisher = titleControl.segmentIndexPublisher
        private(set) lazy var contentControlPublisher = contentControl.segmentIndexPublisher
        private(set) lazy var didTapCreateButtonPublisher = createButton.publisher(for: .touchUpInside)

        private var cancellables: Set<AnyCancellable> = .init()

        private var body: UIView {
            VStackView(spacing: 12) {
                titleControl
                contentControl
                buttonView
            }
            .configure {
                $0.setCustomSpacing(32, after: contentControl)
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

        private let titleControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.title
        )

        private let contentControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.content
        )

        private let createButton = UIButton(type: .system)
            .apply(.debugCreateButton)

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupEvent()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugMemoCreateContentView {
        func setupEvent() {
            didTapCreateButtonPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.createButton.setTitle(
                        L10n.Components.Button.createDone,
                        for: .normal
                    )

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.createButton.setTitle(
                            L10n.Components.Button.create,
                            for: .normal
                        )
                    }
                }
                .store(in: &cancellables)
        }
    }

    // MARK: - protocol

    extension DebugMemoCreateContentView: ContentView {
        func setupView() {
            backgroundColor = .primary

            addSubview(body) {
                $0.edges.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugMemoCreateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugMemoCreateContentView()
            )
        }
    }
#endif
