import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProjectUpdateTextInputView: UIView {
    private(set) lazy var didChangeInputTextPublisher = inputTextField.textDidChangePublisher

    private var body: UIView {
        VStackView(spacing: 12) {
            titleView.configure {
                $0.configure(
                    title: L10n.Profile.Project.title,
                    icon: Asset.projectTitle.image
                )
            }

            VStackView(spacing: 4) {
                inputTextField.configure {
                    $0.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 0))
                    $0.leftViewMode = .always
                    $0.delegate = self
                    $0.placeholder = L10n.Profile.Placeholder.Project.title
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

extension ProjectUpdateTextInputView {
    func updateValue(modelObject: ProjectModelObject?) {
        guard let modelObject else {
            return
        }

        inputTextField.text = modelObject.title
    }
}

// MARK: - private methods

private extension ProjectUpdateTextInputView {
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

extension ProjectUpdateTextInputView: UITextFieldDelegate {
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

    struct ProjectUpdateTextInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProjectUpdateTextInputView())
        }
    }
#endif