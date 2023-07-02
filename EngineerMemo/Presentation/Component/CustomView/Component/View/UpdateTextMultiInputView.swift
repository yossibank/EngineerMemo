import UIKit
import UIKitHelper

// MARK: - properties & init

final class UpdateTextMultiInputView: UIView {
    private(set) lazy var didChangeInputTextPublisher = inputTextView.textDidChangePublisher

    private var body: UIView {
        VStackView(spacing: 8) {
            titleView

            VStackView(spacing: 4) {
                inputTextView
                    .addSubview(placeholderLabel.configure {
                        $0.textColor = .placeholderText
                        $0.font = .systemFont(ofSize: 17)
                        $0.backgroundColor = .background
                    }) {
                        $0.top.equalToSuperview().inset(8)
                        $0.leading.equalToSuperview().inset(6)
                    }
                    .configure {
                        $0.font = .systemFont(ofSize: 17)
                        $0.backgroundColor = .background
                        $0.isScrollEnabled = false
                        $0.delegate = self
                    }

                borderView
            }
        }
    }

    private let titleView = UpdateTitleView()
    private let placeholderLabel = UILabel()
    private let inputTextView = UITextView()
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

extension UpdateTextMultiInputView {
    func inputValue(_ input: UpdateTextInput) {
        titleView.inputValue(
            title: input.title,
            icon: input.icon
        )

        placeholderLabel.configure {
            $0.text = input.placeholder
        }

        inputTextView.configure {
            $0.keyboardType = input.keyboardType
        }
    }

    func updateValue(_ text: String?) {
        inputTextView.text = text
        placeholderLabel.isHidden = !text.isEmpty
    }
}

// MARK: - private methods

private extension UpdateTextMultiInputView {
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

extension UpdateTextMultiInputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        borderView.changeColor(.inputBorder)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        borderView.changeColor(.primary)
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct UpdateTextMultiInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: UpdateTextMultiInputView())
        }
    }
#endif
