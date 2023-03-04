#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugMemoListCell: UITableViewCell {
        private lazy var baseView = UIView()
            .modifier(\.backgroundColor, .thinGray)
            .modifier(\.clipsToBounds, true)
            .modifier(\.layer.cornerRadius, 8)
            .addSubview(stackView) {
                $0.edges.equalToSuperview().inset(16)
            }

        private var stackView: UIView {
            VStackView(spacing: 16) {
                VStackView(spacing: 8) {
                    UILabel()
                        .modifier(\.text, L10n.Memo.title)
                        .modifier(\.textColor, .secondary)
                        .modifier(\.font, .systemFont(ofSize: 14))

                    titleLabel
                        .modifier(\.font, .boldSystemFont(ofSize: 16))
                        .modifier(\.numberOfLines, 0)
                }

                VStackView(spacing: 8) {
                    UILabel()
                        .modifier(\.text, L10n.Memo.content)
                        .modifier(\.textColor, .secondary)
                        .modifier(\.font, .systemFont(ofSize: 14))

                    contentLabel
                        .modifier(\.font, .boldSystemFont(ofSize: 16))
                        .modifier(\.numberOfLines, 0)
                }
            }
        }

        private let titleLabel = UILabel()
        private let contentLabel = UILabel()

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
    }

    // MARK: - internal methods

    extension DebugMemoListCell {
        func configure(_ modelObject: MemoModelObject) {
            titleLabel.text = modelObject.title
            contentLabel.text = modelObject.content
        }
    }

    // MARK: - private methods

    private extension DebugMemoListCell {
        func setupView() {
            contentView.backgroundColor = .primary

            contentView.addSubview(baseView) {
                $0.top.equalToSuperview()
                $0.bottom.leading.trailing.equalToSuperview().inset(32)
            }
        }
    }

    // MARK: - preview

    struct DebugMemoListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugMemoListCell()) {
                $0.configure(MemoModelObjectBuilder().build())
            }
        }
    }
#endif
