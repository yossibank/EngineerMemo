import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileTextInputView: UIView {
    private(set) lazy var didChangeInputTextPublisher = inputTextField.textDidChangePublisher

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView
                .addSubview(titleLabel) {
                    $0.edges.equalToSuperview().inset(8)
                }
                .addConstraint {
                    $0.height.equalTo(40)
                }
                .apply(.inputView)

            VStackView(spacing: 4) {
                inputTextField.configure {
                    $0.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 0))
                    $0.leftViewMode = .always
                }

                borderView
            }
            .addConstraint {
                $0.height.equalTo(40)
            }
        }
    }

    private let titleView = UIView()

    private let titleLabel = UILabel().configure {
        $0.textColor = .secondaryGray
        $0.font = .boldSystemFont(ofSize: 16)
    }

    private let inputTextField = UITextField()
    private let borderView = BorderView()

    private var cancellables: Set<AnyCancellable> = .init()

    init(
        title: String,
        placeholder: String,
        keyboardType: UIKeyboardType = .default
    ) {
        super.init(frame: .zero)

        setupView(title: title)

        inputTextField.configure {
            $0.keyboardType = keyboardType
            $0.placeholder = placeholder
            $0.delegate = self
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension ProfileTextInputView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            titleView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension ProfileTextInputView {
    func updateValue(
        _ type: ProfileContentType,
        modelObject: ProfileModelObject?
    ) {
        guard let modelObject else {
            return
        }

        let input: String? = {
            switch type {
            case .name:
                return modelObject.name?.notNoSettingText

            case .email:
                return modelObject.email?.notNoSettingText

            case .phoneNumber:
                return modelObject.phoneNumber?.notNoSettingText

            case .address:
                return modelObject.address?.notNoSettingText

            case .station:
                return modelObject.station?.notNoSettingText

            default:
                return nil
            }
        }()

        inputTextField.text = input
    }
}

// MARK: - private methods

private extension ProfileTextInputView {
    func setupView(title: String) {
        configure {
            $0.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }

        titleLabel.text = title
    }
}

// MARK: - delegate

extension ProfileTextInputView: UITextFieldDelegate {
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

    struct ProfileTextInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ProfileTextInputView(
                    title: "title",
                    placeholder: "placeholder",
                    keyboardType: .default
                )
            )
        }
    }
#endif
