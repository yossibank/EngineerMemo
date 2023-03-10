#if DEBUG
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugUserDefaultsTextView: UIView {
        private(set) lazy var didChangeTextPublisher = inputTextField.textDidChangePublisher

        private var body: UIView {
            VStackView(spacing: 32) {
                VStackView(alignment: .center, spacing: 16) {
                    titleLabel
                        .modifier(\.text, L10n.Debug.UserDefaults.value)
                        .modifier(\.font, .boldSystemFont(ofSize: 13))

                    descriptionLabel
                        .modifier(\.font, .boldSystemFont(ofSize: 16))
                        .modifier(\.numberOfLines, 0)
                }

                inputTextField
                    .modifier(\.textAlignment, .center)
            }
        }

        private let titleLabel = UILabel()
        private let descriptionLabel = UILabel()
        private let inputTextField = UnderlinedTextField(color: .darkGray)

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - internal methods

    extension DebugUserDefaultsTextView {
        func updateDescription(_ description: String) {
            descriptionLabel.text = description
        }
    }

    // MARK: - private methods

    private extension DebugUserDefaultsTextView {
        func setupView() {
            addSubview(body) {
                $0.edges.equalToSuperview().inset(16)
            }

            configure {
                $0.backgroundColor = .thinGray
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }
        }
    }

    // MARK: - preview

    struct DebugUserDefaultsTextViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugUserDefaultsTextView()) {
                $0.updateDescription("UserDefaults保存値")
            }
            .frame(height: 200)
        }
    }
#endif
