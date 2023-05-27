#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugPathComponentCell: UITableViewCell {
        var cancellables: Set<AnyCancellable> = .init()

        private(set) lazy var didChangePathTextFieldPublisher = pathTextField.textDidChangePublisher

        private var body: UIView {
            VStackView(spacing: 12) {
                VStackView(spacing: 8) {
                    UILabel().configure {
                        $0.text = L10n.Debug.Api.pathComponent
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 16)
                    }

                    UIView()
                        .addConstraint {
                            $0.height.equalTo(1)
                        }
                        .configure {
                            $0.backgroundColor = .primary
                        }
                }

                pathTextField.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 14)
                    $0.placeholder = L10n.Debug.Api.pathComponentPlaceholder
                    $0.keyboardType = .numberPad
                }
            }
        }

        private let pathTextField = UITextField()

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

    extension DebugPathComponentCell {
        override func prepareForReuse() {
            super.prepareForReuse()

            cancellables.removeAll()
        }
    }

    // MARK: - private methods

    private extension DebugPathComponentCell {
        func setupView() {
            contentView.configure {
                $0.addSubview(body) {
                    $0.top.bottom.equalToSuperview().inset(16)
                    $0.leading.trailing.equalToSuperview().inset(8)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugPathComponentCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugPathComponentCell())
        }
    }
#endif
