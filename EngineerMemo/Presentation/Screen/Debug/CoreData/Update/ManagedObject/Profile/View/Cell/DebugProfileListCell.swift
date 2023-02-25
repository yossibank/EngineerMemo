#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugProfileListCell: UITableViewCell {
        var cancellables: Set<AnyCancellable> = .init()

        private var body: UIView {
            VStackView {
                titleLabel
            }
            .modifier(\.backgroundColor, .primary)
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

    extension DebugProfileListCell {
        func configure(_ title: String) {
            titleLabel.text = title
        }
    }

    // MARK: - private methods

    private extension DebugProfileListCell {
        func setupView() {
            backgroundColor = .primary

            contentView.addSubview(body) {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        }
    }

    // MARK: - preview

    struct DebugProfileListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProfileListCell())
        }
    }
#endif
