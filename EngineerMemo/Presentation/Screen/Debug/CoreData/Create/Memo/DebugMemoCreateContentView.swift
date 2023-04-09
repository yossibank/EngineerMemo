#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugMemoCreateContentView: UIView {
        private(set) lazy var didChangeTitleControlPublisher = titleControl.segmentIndexPublisher
        private(set) lazy var didChangeContentControlPublisher = contentControl.segmentIndexPublisher
        private(set) lazy var didTapCreateButtonPublisher = body.didTapActionButtonPublisher

        private var cancellables: Set<AnyCancellable> = .init()

        private lazy var body = DebugCoreDataSegmentContentView(.create).configure {
            $0.setupContentView(
                view: VStackView(spacing: 12) {
                    titleControl
                    contentControl
                }
            )
        }

        private let titleControl = DebugCoreDataSegmentView(title: L10n.Debug.Segment.title)
        private let contentControl = DebugCoreDataSegmentView(title: L10n.Debug.Segment.content)

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

    extension DebugMemoCreateContentView: ContentView {
        func setupView() {
            configure {
                $0.addSubview(body) {
                    $0.top.leading.trailing.equalToSuperview()
                }

                $0.backgroundColor = .primary
            }
        }
    }

    // MARK: - preview

    struct DebugMemoCreateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugMemoCreateContentView())
        }
    }
#endif
