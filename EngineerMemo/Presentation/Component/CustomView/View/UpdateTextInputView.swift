import UIKit

// MARK: - properties & init

final class UpdateTextInputView: UIView {
    private(set) lazy var didChangeInputTextPublisher = inputTextField.textDidChangePublisher

    private var body: UIView {
        VStackView(spacing: 8) {
            titleView

            VStackView(spacing: 4) {
                inputTextField.configure {
                    $0.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 0))
                    $0.leftViewMode = .always
                    $0.delegate = self
                }

                borderView
            }
            .addConstraint {
                $0.height.equalTo(40)
            }
        }
    }

    private let titleView = UpdateTitleView()
    private let inputTextField = UITextField()
    private let borderView = BorderView()

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

extension UpdateTextInputView {
    func setInputType(_ input: UpdateTextInput) {
        titleView.setTitle(
            title: input.title,
            icon: input.icon
        )

        inputTextField.configure {
            $0.keyboardType = input.keyboardType
            $0.placeholder = input.placeholder
        }
    }

    func setInputValue(_ text: String?) {
        inputTextField.text = text
    }
}

// MARK: - private methods

private extension UpdateTextInputView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview().inset(8)
                $0.horizontalEdges.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - delegate

extension UpdateTextInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        borderView.changeColor(.inputBorder)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        borderView.changeColor(.primary)
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct UpdateTextInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: UpdateTextInputView()) {
                $0.setInputType(.init(
                    title: "title",
                    icon: Asset.penguin.image,
                    placeholder: "placeholder"
                ))
            }
            .frame(height: 110)
        }
    }
#endif
