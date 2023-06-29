#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugMemoCreateContentView: UIView {
        private(set) lazy var didChangeCategoryControlPublisher = categoryControl.$selectedCategory
        private(set) lazy var didChangeTitleControlPublisher = titleControl.segmentIndexPublisher
        private(set) lazy var didChangeContentControlPublisher = contentControl.segmentIndexPublisher
        private(set) lazy var didTapUpdateButtonPublisher = body.didTapActionButtonPublisher

        private var cancellables = Set<AnyCancellable>()

        private lazy var body = DebugCoreDataSegmentContentView(.create).configure {
            $0.setupContentView(
                view: VStackView(spacing: 12) {
                    categoryControl
                    titleControl
                    contentControl
                }
            )
        }

        private let categoryControl = DebugCategoryMenuView(title: L10n.Debug.Menu.category)
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
                    $0.top.horizontalEdges.equalToSuperview()
                }

                $0.backgroundColor = .background
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
