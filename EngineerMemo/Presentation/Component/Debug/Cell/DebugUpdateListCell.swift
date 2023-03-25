#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugUpdateListCell: UITableViewCell {
        private var body: UIView {
            VStackView {
                titleLabel
            }
        }

        private let titleLabel = UILabel()

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

        override func setSelected(
            _ selected: Bool,
            animated: Bool
        ) {
            super.setSelected(
                selected,
                animated: animated
            )

            accessoryType = selected ? .checkmark : .none
        }
    }

    // MARK: - internal methods

    extension DebugUpdateListCell {
        func configure(_ title: String) {
            titleLabel.text = title
        }
    }

    // MARK: - private methods

    private extension DebugUpdateListCell {
        func setupView() {
            configure {
                $0.backgroundColor = .primary
                $0.separatorInset = .zero
                $0.selectionStyle = .none
            }

            contentView.addSubview(body) {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        }
    }

    // MARK: - preview

    struct DebugUpdateListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugUpdateListCell()) {
                $0.configure("title")
            }
        }
    }
#endif
