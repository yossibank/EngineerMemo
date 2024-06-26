#if DEBUG
    import Combine
    import SwiftUI
    import UIKit

    // MARK: - properties & init

    final class DebugUpdateListCell: UITableViewCell {
        private var body: UIView {
            VStackView {
                titleLabel.configure {
                    $0.textColor = .primary
                    $0.font = .systemFont(ofSize: 16)
                    $0.numberOfLines = 1
                }
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
    }

    // MARK: - override methods

    extension DebugUpdateListCell {
        override func setSelected(
            _ selected: Bool,
            animated: Bool
        ) {
            super.setSelected(
                selected,
                animated: animated
            )

            accessoryView?.isHidden = !selected
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
                $0.backgroundColor = .background
                $0.separatorInset = .zero
                $0.selectionStyle = .none
                $0.accessoryView = UIImageView().configure {
                    $0.frame = .init(x: 0, y: 0, width: 20, height: 20)
                    $0.image = Asset.checkmark.image
                }
            }

            contentView.configure {
                $0.addSubview(body) {
                    $0.verticalEdges.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(16)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugUpdateListCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugUpdateListCell()) {
                $0.configure("title")
            }
            .frame(height: 60)
        }
    }
#endif
