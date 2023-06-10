import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileUpdateTextInputView: UIView {
    private(set) lazy var didChangeInputTextPublisher = inputTextField.textDidChangePublisher

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView

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

    private let titleView = ProfileUpdateTitleView()
    private let inputTextField = UITextField()
    private let borderView = BorderView()

    init(_ type: ProfileContentType) {
        super.init(frame: .zero)

        var title: String?
        var icon: UIImage?
        var placeholder: String?
        var keyboardType: UIKeyboardType = .default

        switch type {
        case .name:
            title = L10n.Profile.name
            icon = Asset.profileName.image
            placeholder = L10n.Profile.Example.name

        case .email:
            title = L10n.Profile.email
            icon = Asset.profileEmail.image
            placeholder = L10n.Profile.Example.email
            keyboardType = .emailAddress

        case .phoneNumber:
            title = L10n.Profile.phoneNumber
            icon = Asset.profilePhoneNumber.image
            placeholder = L10n.Profile.Example.phoneNumber
            keyboardType = .numberPad

        case .address:
            title = L10n.Profile.address
            icon = Asset.profileAddress.image
            placeholder = L10n.Profile.Example.address

        case .station:
            title = L10n.Profile.station
            icon = Asset.profileStation.image
            placeholder = L10n.Profile.Example.station

        default:
            title = .empty
        }

        setupView()

        titleView.configure(
            title: title,
            icon: icon
        )

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

// MARK: - internal methods

extension ProfileUpdateTextInputView {
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

private extension ProfileUpdateTextInputView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - delegate

extension ProfileUpdateTextInputView: UITextFieldDelegate {
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

    struct ProfileUpdateTextInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileUpdateTextInputView(.name))
        }
    }
#endif
