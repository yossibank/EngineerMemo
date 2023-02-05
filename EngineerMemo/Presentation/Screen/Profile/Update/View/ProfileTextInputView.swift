import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - stored properties & init

final class ProfileTextInputView: UIView {
    private(set) lazy var inputPublisher = inputTextField.textDidChangePublisher

    private lazy var stackView = UIStackView(
        styles: [
            .addArrangedSubviews(arrangedSubviews),
            .axis(.vertical)
        ]
    )

    private lazy var arrangedSubviews = [
        titleView,
        textInputView
    ]

    private lazy var titleView = UIView(
        styles: [
            .addSubview(titleLabel),
            .backgroundColor(.thinGray),
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(4)
        ]
    )

    private lazy var textInputView = UIView(
        styles: [
            .addSubview(inputTextField),
            .backgroundColor(.primary)
        ]
    )

    private let titleLabel = UILabel(
        styles: [
            .boldSystemFont(size: 16),
            .textColor(.secondary)
        ]
    )

    private let inputTextField = UITextField(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .borderStyle(.roundedRect),
            .clipsToBounds(true),
            .cornerRadius(4)
        ]
    )

    private var cancellables: Set<AnyCancellable> = .init()

    init(
        title: String,
        placeholder: String,
        keyboardType: UIKeyboardType = .default
    ) {
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
        setupTextField()

        titleLabel.apply(.text(title))
        inputTextField.apply([
            .keyboardType(keyboardType),
            .placeholder(placeholder)
        ])

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
                $0.apply(.borderColor(.theme))
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
            input = modelObject.name

        case .email:
            input = modelObject.email

        case .phoneNumber:
            input = modelObject.phoneNumber

        case .address:
            input = modelObject.address

        case .station:
            input = modelObject.station

        default:
            input = ""
        }

        inputTextField.apply(.text(input))
    }
}

// MARK: - private methods

private extension ProfileTextInputView {
    func setupViews() {
        apply([
            .addSubview(stackView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        titleView.snp.makeConstraints {
            $0.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        textInputView.snp.makeConstraints {
            $0.height.equalTo(80)
        }

        inputTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
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
