#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugMemoUpdateCell: UITableViewCell {
        var cancellables: Set<AnyCancellable> = .init()

        private(set) lazy var titleControlPublisher = titleControl.segmentIndexPublisher
        private(set) lazy var contentControlPublisher = contentControl.segmentIndexPublisher
        private(set) lazy var didTapUpdateButtonPublisher = body.didTapActionButtonPublisher

        private lazy var body = DebugCoreDataSegmentContentView()
            .configure {
                $0.setupContentView(
                    view: VStackView(spacing: 12) {
                        titleControl
                        contentControl
                    },
                    type: .update
                )
            }

        private let titleControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.title
        )

        private let contentControl = DebugCoreDataSegmentView(
            title: L10n.Debug.Segment.content
        )

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
            backgroundColor = .primary
            selectionStyle = .none

            contentView.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(16)
                $0.leading.trailing.equalToSuperview()
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
