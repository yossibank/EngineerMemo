import UIKit

// MARK: - properties & init

final class UnderlinedTextField: UITextField {
    private let color: UIColor
    private let underlineLayer = CALayer()

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

// MARK: - override methods

extension UnderlinedTextField {
    override func layoutSubviews() {
        super.layoutSubviews()

        setupUnderlineLayer()
    }
}

// MARK: - internal methods

extension UnderlinedTextField {
    func changeColor(_ color: UIColor) {
        underlineLayer.borderColor = color.cgColor
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
