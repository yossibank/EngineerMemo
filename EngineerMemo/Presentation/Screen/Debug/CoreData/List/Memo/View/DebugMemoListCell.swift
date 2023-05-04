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
                createStackView(.category)
                createStackView(.title)
                createStackView(.content)
            }
        }

        private let categoryLabel = UILabel()
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
            categoryLabel.text = modelObject.category?.value ?? .noSetting
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

        func createStackView(_ type: MemoContentType) -> UIStackView {
            let valueLabel: UILabel

            switch type {
            case .category:
                valueLabel = categoryLabel

            case .title:
                valueLabel = titleLabel
                valueLabel.configure {
                    $0.numberOfLines = 0
                }

            case .content:
                valueLabel = contentLabel
                valueLabel.configure {
                    $0.numberOfLines = 0
                }
            }

            return VStackView(alignment: .leading, spacing: 8) {
                UILabel().configure {
                    $0.text = type.title
                    $0.textColor = .secondaryGray
                    $0.font = .systemFont(ofSize: 14)
                }

                valueLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 16)
                }
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
