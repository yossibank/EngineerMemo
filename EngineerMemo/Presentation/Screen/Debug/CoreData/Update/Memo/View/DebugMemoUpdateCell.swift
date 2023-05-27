#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugMemoUpdateCell: UITableViewCell {
        var cancellables: Set<AnyCancellable> = .init()

        private(set) lazy var categoryControlPublisher = categoryControl.$selectedCategory
        private(set) lazy var titleControlPublisher = titleControl.segmentIndexPublisher
        private(set) lazy var contentControlPublisher = contentControl.segmentIndexPublisher
        private(set) lazy var didTapUpdateButtonPublisher = body.didTapActionButtonPublisher

        private lazy var body = DebugCoreDataSegmentContentView(.update).configure {
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

    // MARK: - private methods

    private extension DebugMemoUpdateCell {
        func setupView() {
            configure {
                $0.separatorInset = .zero
                $0.selectionStyle = .none
            }

            contentView.configure {
                $0.addSubview(body) {
                    $0.top.bottom.equalToSuperview().inset(16)
                    $0.leading.trailing.equalToSuperview()
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugMemoUpdateCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugMemoUpdateCell())
        }
    }
#endif
