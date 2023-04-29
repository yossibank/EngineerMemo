#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugParametersCell: UITableViewCell {
        var cancellables: Set<AnyCancellable> = .init()

        private(set) lazy var didChangeUserIdTextFieldPublisher = userIdTextField.textDidChangePublisher
        private(set) lazy var didChangeIdTextFieldPublisher = idTextField.textDidChangePublisher
        private(set) lazy var didChangeTitleTextFieldPublisher = titleTextField.textDidChangePublisher
        private(set) lazy var didChangeBodyTextFieldPublisher = bodyTextField.textDidChangePublisher

        private var body: UIView {
            VStackView(spacing: 12) {
                VStackView(spacing: 8) {
                    UILabel().configure {
                        $0.text = L10n.Debug.Api.parameters
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

                VStackView(spacing: 12) {
                    userIdTextField.configure {
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 14)
                        $0.placeholder = L10n.Debug.Api.Parameters.userId
                        $0.keyboardType = .numberPad
                        $0.isHidden = true
                    }

                    idTextField.configure {
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 14)
                        $0.placeholder = L10n.Debug.Api.Parameters.id
                        $0.keyboardType = .numberPad
                        $0.isHidden = true
                    }

                    titleTextField.configure {
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 14)
                        $0.placeholder = L10n.Debug.Api.Parameters.title
                        $0.keyboardType = .default
                        $0.isHidden = true
                    }

                    bodyTextField.configure {
                        $0.textColor = .primary
                        $0.font = .boldSystemFont(ofSize: 14)
                        $0.placeholder = L10n.Debug.Api.Parameters.body
                        $0.keyboardType = .default
                        $0.isHidden = true
                    }
                }
            }
        }

        private let userIdTextField = UITextField()
        private let idTextField = UITextField()
        private let titleTextField = UITextField()
        private let bodyTextField = UITextField()

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

        override func prepareForReuse() {
            super.prepareForReuse()

            cancellables.removeAll()
        }
    }

    // MARK: - internal methods

    extension DebugParametersCell {
        func configure(with parameters: [DebugAPIViewModel.Parameters]) {
            userIdTextField.isHidden = !parameters.contains(.userId)
            idTextField.isHidden = !parameters.contains(.id)
            titleTextField.isHidden = !parameters.contains(.title)
            bodyTextField.isHidden = !parameters.contains(.body)
        }
    }

    // MARK: - private methods

    private extension DebugParametersCell {
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

    struct DebugParametersCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugParametersCell())
        }
    }
#endif
