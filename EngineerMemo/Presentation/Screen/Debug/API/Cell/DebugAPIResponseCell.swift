#if DEBUG
    import Combine
    import SwiftUI
    import UIKit

    // MARK: - properties & init

    final class DebugAPIResponseCell: UITableViewCell {
        private var body: UIView {
            VStackView(spacing: 12) {
                VStackView(spacing: 8) {
                    UILabel().configure {
                        $0.text = L10n.Debug.Api.resultResponse
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 16)
                    }

                    BorderView()
                }

                responseLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 14)
                    $0.numberOfLines = 0
                }
            }
        }

        private let responseLabel = UILabel()

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

    extension DebugAPIResponseCell {
        override func prepareForReuse() {
            super.prepareForReuse()

            responseLabel.text = .empty
        }
    }

    // MARK: - internal methods

    extension DebugAPIResponseCell {
        func configure(with text: String?) {
            responseLabel.text = text
        }
    }

    // MARK: - private methods

    private extension DebugAPIResponseCell {
        func setupView() {
            contentView.configure {
                $0.addSubview(body) {
                    $0.verticalEdges.equalToSuperview().inset(16)
                    $0.horizontalEdges.equalToSuperview().inset(8)
                }

                $0.backgroundColor = .background
            }
        }
    }

    // MARK: - preview

    struct DebugAPIResponseCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugAPIResponseCell()) {
                $0.configure(with: "title")
            }
        }
    }
#endif
