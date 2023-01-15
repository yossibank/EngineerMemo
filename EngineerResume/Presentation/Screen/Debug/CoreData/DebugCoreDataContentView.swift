#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - stored properties & init

    final class DebugCoreDataContentView: UIView {
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

    extension DebugCoreDataContentView {}

    // MARK: - private methods

    private extension DebugCoreDataContentView {}

    // MARK: - protocol

    extension DebugCoreDataContentView: ContentView {
        func setupViews() {}
        func setupConstraints() {}
    }

    // MARK: - preview

    struct DebugCoreDataContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: DebugCoreDataContentView()
            )
        }
    }
#endif
