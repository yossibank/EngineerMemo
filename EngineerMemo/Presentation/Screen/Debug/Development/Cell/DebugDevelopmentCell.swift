#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugDevelopmentCell: UITableViewCell {
        private var body: UIView {
            HStackView(spacing: 8) {
                titleLabel.configure {
                    $0.textColor = .primary
                    $0.font = .systemFont(ofSize: 14)
                }

                subTitleLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 14)
                }
            }
        }

        private let titleLabel = UILabel()
        private let subTitleLabel = UILabel()

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

    extension DebugDevelopmentCell {
        func configure(item: DebugDevelopmentContentViewItem) {
            titleLabel.text = item.title
            subTitleLabel.text = item.subTitle

            if item.subTitle.isNil {
                titleLabel.font = .boldSystemFont(ofSize: 14)
            }
        }
    }

    // MARK: - private methods

    private extension DebugDevelopmentCell {
        func setupView() {
            contentView.configure {
                $0.addSubview(body) {
                    $0.centerY.equalToSuperview()
                    $0.leading.equalToSuperview().inset(8)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugDevelopmentCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugDevelopmentCell()) {
                $0.configure(item: .init(
                    title: "title",
                    subTitle: "subTitle"
                ))
            }
        }
    }
#endif
