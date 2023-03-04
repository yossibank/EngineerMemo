#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugDevelopmentCell: UITableViewCell {
        private var body: UIView {
            HStackView(spacing: 8) {
                titleLabel
                    .modifier(\.font, .systemFont(ofSize: 14))

                subTitleLabel
                    .modifier(\.font, .boldSystemFont(ofSize: 14))
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

            if item.subTitle == nil {
                titleLabel.font = .boldSystemFont(ofSize: 14)
            }
        }
    }

    // MARK: - private methods

    private extension DebugDevelopmentCell {
        func setupView() {
            contentView.backgroundColor = .primary

            contentView.addSubview(body) {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(8)
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
