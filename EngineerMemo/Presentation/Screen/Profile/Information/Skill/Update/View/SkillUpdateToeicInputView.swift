import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class SkillUpdateToeicInputView: UIView {
    private(set) lazy var didChangeInputScorePublisher = inputTextField.textDidChangePublisher.compactMap {
        Int($0)
    }

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView.configure {
                $0.configure(
                    title: L10n.Profile.toeic,
                    icon: Asset.toeic.image
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

extension SkillUpdateToeicInputView {
    func updateValue(modelObject: SkillModelObject?) {
        guard let modelObject else {
            return
        }

        inputTextField.text = modelObject.toeic?.description
    }
}

// MARK: - private methods

private extension SkillUpdateToeicInputView {
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

extension SkillUpdateToeicInputView: UITextFieldDelegate {
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

    struct SkillUpdateToeicInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: SkillUpdateToeicInputView())
        }
    }
#endif
