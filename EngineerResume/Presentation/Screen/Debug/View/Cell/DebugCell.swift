#if DEBUG
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - properties & init

    final class DebugCell: UITableViewCell {
        private let titleLabel = UILabel(style: .bold16)

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
        func configure(title: String) {
            titleLabel.text = title
        }
    }

    // MARK: - private methods

    private extension DebugCell {
        func setupViews() {
            contentView.apply(.backgroundPrimary)
            contentView.addSubview(titleLabel)
        }

        func setupConstraints() {
            titleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(8)
            }
        }
    }

    // MARK: - preview

    struct DebugCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugCell()) {
                $0.configure(title: "Test")
            }
        }
    }
#endif
