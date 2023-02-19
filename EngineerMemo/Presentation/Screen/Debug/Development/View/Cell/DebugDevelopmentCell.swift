#if DEBUG
    import SnapKit
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

            setupViews()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }

    // MARK: - internal methods

    extension DebugDevelopmentCell {
        func configure(item: DebugDevelopmentItem) {
            titleLabel.modifier(\.text, item.title)
            subTitleLabel.modifier(\.text, item.subTitle)

            if item.subTitle == nil {
                titleLabel.modifier(\.font, .boldSystemFont(ofSize: 14))
            }
        }
    }

    // MARK: - private methods

    private extension DebugDevelopmentCell {
        func setupViews() {
            contentView.modifier(\.backgroundColor, .primary)

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
