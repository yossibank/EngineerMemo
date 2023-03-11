import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileTextInputView: UIView {
    private(set) lazy var didChangeInputTextPublisher = inputTextField.textDidChangePublisher

    private var body: UIView {
        VStackView {
            titleView
                .modifier(\.layer.borderColor, UIColor.theme.cgColor)
                .modifier(\.layer.borderWidth, 1.0)
                .modifier(\.layer.cornerRadius, 4)
                .modifier(\.clipsToBounds, true)
                .modifier(\.backgroundColor, .thinGray)

            textInputView
        }
    }

    private lazy var titleView = UIView()
        .addSubview(titleLabel) {
            $0.edges.equalToSuperview().inset(8)
        }
        .addConstraint {
            $0.height.equalTo(40)
        }

    private lazy var textInputView = UIView()
        .addSubview(inputTextField) {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
        }
        .addConstraint {
            $0.height.equalTo(80)
        }

    private let titleLabel = UILabel()
        .modifier(\.textColor, .secondary)
        .modifier(\.font, .boldSystemFont(ofSize: 16))

    private let inputTextField = UITextField()
        .modifier(\.layer.borderColor, UIColor.theme.cgColor)
        .modifier(\.layer.borderWidth, 1.0)
        .modifier(\.layer.cornerRadius, 4)
        .modifier(\.borderStyle, .roundedRect)
        .modifier(\.clipsToBounds, true)

    private var cancellables: Set<AnyCancellable> = .init()

    init(
        title: String,
        placeholder: String,
        keyboardType: UIKeyboardType = .default
    ) {
        super.init(frame: .zero)

        setupView()
        setupTextField()

        titleLabel.text = title

        inputTextField.configure {
            $0.keyboardType = keyboardType
            $0.placeholder = placeholder
        }

        if keyboardType == .numberPad {
            setupNumberPad()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [titleView, inputTextField].forEach {
                $0.layer.borderColor = UIColor.theme.cgColor
            }
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

        let input: String?

        switch type {
        case .name:
            input = modelObject.name?.notNoSettingText

        case .email:
            input = modelObject.email?.notNoSettingText

        case .phoneNumber:
            input = modelObject.phoneNumber?.notNoSettingText

        case .address:
            input = modelObject.address?.notNoSettingText

        case .station:
            input = modelObject.station?.notNoSettingText

        default:
            input = nil
        }

        inputTextField.text = input
    }
}

// MARK: - private methods

private extension ProfileTextInputView {
    func setupView() {
        backgroundColor = .primary

        addSubview(body) {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func setupTextField() {
        inputTextField.delegate = self
    }

    func setupNumberPad() {
        let toolBar = UIToolbar()

        let spaceBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let doneBarButtonItem = UIBarButtonItem(
            title: L10n.Common.done,
            style: .done,
            target: nil,
            action: nil
        )

        doneBarButtonItem.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.inputTextField.resignFirstResponder()
            }
            .store(in: &cancellables)

        toolBar.items = [spaceBarButtonItem, doneBarButtonItem]
        toolBar.sizeToFit()

        inputTextField.inputAccessoryView = toolBar
    }
}

// MARK: - delegate

extension ProfileTextInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
