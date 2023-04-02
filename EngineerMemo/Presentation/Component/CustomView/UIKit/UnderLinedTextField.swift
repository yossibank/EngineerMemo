import UIKit

// MARK: - properties & init

final class UnderlinedTextField: UITextField {
    private let color: UIColor
    private let underlineLayer = CALayer()
    private let paddingInsets: UIEdgeInsets = .init(.vertical, 4)

    init(color: UIColor) {
        self.color = color

        super.init(frame: .zero)

        layer.addSublayer(underlineLayer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override init

extension UnderlinedTextField {
    override func layoutSubviews() {
        super.layoutSubviews()

        setupUnderlineLayer()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: paddingInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: paddingInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: paddingInsets)
    }
}

// MARK: - private methods

private extension UnderlinedTextField {
    func setupUnderlineLayer() {
        var frame = bounds
        frame.origin.y = frame.size.height - 1
        frame.size.height = 1

        underlineLayer.frame = frame
        underlineLayer.backgroundColor = color.cgColor
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct UnderlinedTextFieldPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: UnderlinedTextField(color: .blue)) {
                $0.text = "TEXT FIELD"
            }
        }
    }
#endif
