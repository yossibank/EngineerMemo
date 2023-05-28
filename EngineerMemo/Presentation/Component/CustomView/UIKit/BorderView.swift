import UIKit
import UIKitHelper

// MARK: - properties & init

final class BorderView: UIView {
    private let border = UIView().configure {
        $0.backgroundColor = .primary
    }

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

extension BorderView {
    func changeColor(_ color: UIColor) {
        border.backgroundColor = color
    }
}

// MARK: - private methods

private extension BorderView {
    func setupView() {
        configure {
            $0.addSubview(border) {
                $0.height.equalTo(1)
                $0.edges.equalToSuperview()
            }
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct BorderViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: BorderView())
        }
    }
#endif
