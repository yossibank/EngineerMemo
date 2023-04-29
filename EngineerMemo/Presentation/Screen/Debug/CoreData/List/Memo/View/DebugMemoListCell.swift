#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugMemoListCell: UITableViewCell {
        private lazy var baseView = UIView()
            .addSubview(stackView) {
                $0.edges.equalToSuperview().inset(16)
            }
            .configure {
                $0.backgroundColor = .primaryGray
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }

        private var stackView: UIView {
            VStackView(spacing: 16) {
                VStackView(spacing: 8) {
                    UILabel().configure {
                        $0.text = L10n.Memo.title
                        $0.textColor = .secondaryGray
                        $0.font = .systemFont(ofSize: 14)
                    }

                    titleLabel.configure {
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 16)
                        $0.numberOfLines = 0
                    }
                }

                VStackView(spacing: 8) {
                    UILabel().configure {
                        $0.text = L10n.Memo.content
                        $0.textColor = .secondaryGray
                        $0.font = .systemFont(ofSize: 14)
                    }

                    contentLabel.configure {
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 16)
                        $0.numberOfLines = 0
                    }
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
            contentView.configure {
                $0.addSubview(baseView) {
                    $0.top.bottom.equalToSuperview().inset(8)
                    $0.leading.trailing.equalToSuperview().inset(32)
                }

                $0.backgroundColor = .background
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
