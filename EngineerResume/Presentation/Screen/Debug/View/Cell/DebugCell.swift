#if DEBUG
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - properties & init

    final class DebugCell: UITableViewCell {
        private lazy var stackView: UIStackView = {
            $0.axis = .horizontal
            $0.spacing = 8
            return $0
        }(UIStackView(arrangedSubviews: [
            titleLabel,
            subTitleLabel
        ]))

        private let titleLabel = UILabel(style: .system14)
        private let subTitleLabel = UILabel(style: .bold14)

        override init(
            style: UITableViewCell.CellStyle,
            reuseIdentifier: String?
        ) {
            super.init(
                style: style,
                reuseIdentifier: reuseIdentifier
            )

            setupViews()
            setupConstraints()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }

    // MARK: - internal methods

    extension DebugCell {
        func configure(item: DebugItem) {
            titleLabel.text = item.title
            subTitleLabel.text = item.subTitle
        }
    }

    // MARK: - private methods

    private extension DebugCell {
        func setupViews() {
            contentView.apply(.backgroundPrimary)
            contentView.addSubview(stackView)
        }

        func setupConstraints() {
            stackView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(8)
            }
        }
    }

    // MARK: - preview

    struct DebugCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugCell()) {
                $0.configure(item: .init(
                    title: "title",
                    subTitle: "subTitle"
                ))
            }
        }
    }
#endif
