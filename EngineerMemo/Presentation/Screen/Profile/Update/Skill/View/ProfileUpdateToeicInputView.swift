import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileUpdateToeicInputView: UIView {
    private(set) lazy var didChangeInputTextPublisher = inputTextField.textDidChangePublisher

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView.configure {
                $0.configure(
                    title: L10n.Profile.toeic,
                    icon: Asset.profileToeic.image
                )
            }

            VStackView(spacing: 4) {
                inputTextField.configure {
                    $0.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 0))
                    $0.leftViewMode = .always
                    $0.keyboardType = .numberPad
                    $0.placeholder = L10n.Profile.Example.toeic
                    $0.delegate = self
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

extension ProfileUpdateToeicInputView {}

// MARK: - private methods

private extension ProfileUpdateToeicInputView {
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

extension ProfileUpdateToeicInputView: UITextFieldDelegate {
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

    struct ProfileUpdateToeicInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileUpdateToeicInputView())
        }
    }
#endif
