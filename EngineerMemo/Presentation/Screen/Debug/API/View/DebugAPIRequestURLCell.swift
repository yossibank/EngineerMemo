#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugAPIRequestURLCell: UITableViewCell {
        private var body: UIView {
            VStackView(spacing: 12) {
                VStackView(spacing: 8) {
                    HStackView(spacing: 4) {
                        UILabel().configure {
                            $0.text = L10n.Debug.Api.requestURL
                            $0.textColor = .primary
                            $0.font = .boldSystemFont(ofSize: 16)
                        }

                        httpMethodLabel.configure {
                            $0.textColor = .primary
                            $0.font = .boldSystemFont(ofSize: 16)
                        }

                        UIView()
                    }

                    UIView()
                        .addConstraint {
                            $0.height.equalTo(1)
                        }
                        .configure {
                            $0.backgroundColor = .primary
                        }
                }

                requestLabel.configure {
                    $0.textColor = .primary
                    $0.font = .boldSystemFont(ofSize: 14)
                    $0.numberOfLines = 0
                }
            }
        }

        private let httpMethodLabel = UILabel()
        private let requestLabel = UILabel()

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

    extension DebugAPIRequestURLCell {
        func configure(
            httpMethod: String,
            requestURL: String
        ) {
            httpMethodLabel.text = L10n.Debug.Api.httpMethod(httpMethod)
            requestLabel.text = requestURL
        }
    }

    // MARK: - private methods

    private extension DebugAPIRequestURLCell {
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

    struct DebugAPIRequestURLCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugAPIRequestURLCell()) {
                $0.configure(
                    httpMethod: "GET",
                    requestURL: "https://exmaple.com"
                )
            }
        }
    }
#endif
