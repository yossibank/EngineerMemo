import UIKit
import UIKitHelper

// MARK: - properties & init

final class BasicUpdateTextInputView: UIView {
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

    private let titleView = UpdateTitleView()
    private let inputTextField = UITextField()
    private let borderView = BorderView()

    init(_ type: ProfileBasicContentType) {
        super.init(frame: .zero)

        var title: String?
        var icon: UIImage?
        var placeholder: String?
        var keyboardType: UIKeyboardType = .default

        switch type {
        case .name:
            title = L10n.Profile.name
            icon = Asset.myName.image
            placeholder = L10n.Profile.Example.name

        case .email:
            title = L10n.Profile.email
            icon = Asset.email.image
            placeholder = L10n.Profile.Example.email
            keyboardType = .emailAddress

        case .phoneNumber:
            title = L10n.Profile.phoneNumber
            icon = Asset.phoneNumber.image
            placeholder = L10n.Profile.Example.phoneNumber
            keyboardType = .numberPad

        case .address:
            title = L10n.Profile.address
            icon = Asset.address.image
            placeholder = L10n.Profile.Example.address

        case .station:
            title = L10n.Profile.station
            icon = Asset.station.image
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

extension BasicUpdateTextInputView {
    func updateValue(
        _ type: ProfileBasicContentType,
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

private extension BasicUpdateTextInputView {
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

extension BasicUpdateTextInputView: UITextFieldDelegate {
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

    struct BasicUpdateTextInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: BasicUpdateTextInputView(.name))
        }
    }
#endif