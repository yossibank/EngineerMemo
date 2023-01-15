#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - stored properties & init

    final class DebugCoreDataCreateContentView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
            setupConstraints()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - internal methods

    extension DebugCoreDataCreateContentView {}

    // MARK: - private methods

    private extension DebugCoreDataCreateContentView {}

    // MARK: - protocol

    extension DebugCoreDataCreateContentView: ContentView {
        func setupViews() {}
        func setupConstraints() {}
    }

    // MARK: - preview

    struct DebugCoreDataCreateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugCoreDataCreateContentView()
            )
        }
    }
#endif
