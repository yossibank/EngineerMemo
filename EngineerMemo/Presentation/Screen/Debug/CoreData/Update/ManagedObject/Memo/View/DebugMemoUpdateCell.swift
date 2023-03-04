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
        private(set) lazy var didTapUpdateButtonPublisher = updateButton.publisher(for: .touchUpInside)

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
            .addSubview(updateButton) {
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

        private let updateButton = UIButton(type: .system)
            .apply(.debugUpdateButton)

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

    // MARK: - internal methods

    extension DebugMemoUpdateCell {
        func updateView() {
            updateButton.setTitle(
                L10n.Components.Button.updateDone,
                for: .normal
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateButton.setTitle(
                    L10n.Components.Button.update,
                    for: .normal
                )
            }
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
