#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugMemoListCell: UITableViewCell {
        private lazy var baseView = UIView()
            .addSubview(createdLabel) {
                $0.top.equalToSuperview().inset(16)
                $0.trailing.equalToSuperview().inset(8)
            }
            .addSubview(body) {
                $0.edges.equalToSuperview().inset(16)
            }
            .configure {
                $0.backgroundColor = .primaryGray
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }

        private var body: UIView {
            VStackView(spacing: 16) {
                categoryView.configure {
                    $0.setTitle(title: L10n.Memo.category)
                }

                titleView.configure {
                    $0.setTitle(title: L10n.Memo.title)
                }

                contentsView.configure {
                    $0.setTitle(title: L10n.Memo.content)
                }
            }
        }

        private let createdLabel = UILabel().configure {
            $0.textColor = .primary
            $0.font = .boldSystemFont(ofSize: 12)
        }

        private let categoryView = TitleContentView()
        private let titleView = TitleContentView()
        private let contentsView = TitleContentView()

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
            createdLabel.text = modelObject.createdAt.toString
            categoryView.setContent(modelObject.category?.value ?? .noSetting)
            titleView.setContent(modelObject.title)
            contentsView.setContent(modelObject.content)
        }
    }

    // MARK: - private methods

    private extension DebugMemoListCell {
        func setupView() {
            contentView.configure {
                $0.addSubview(baseView) {
                    $0.verticalEdges.equalToSuperview().inset(8)
                    $0.horizontalEdges.equalToSuperview().inset(32)
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
