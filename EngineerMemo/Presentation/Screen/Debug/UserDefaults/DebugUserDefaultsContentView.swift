import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class DebugUserDefaultsContentView: UIView {
    private var body: UIView {
        VStackView(alignment: .center) {
            UILabel()
                .modifier(\.text, "Hello World!")
        }
        .modifier(\.backgroundColor, .primary)
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

extension DebugUserDefaultsContentView {}

// MARK: - private methods

private extension DebugUserDefaultsContentView {}

// MARK: - protocol

extension DebugUserDefaultsContentView: ContentView {
    func setupView() {
        addSubview(body) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct DebugUserDefaultsContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugUserDefaultsContentView()
            )
        }
    }
#endif
