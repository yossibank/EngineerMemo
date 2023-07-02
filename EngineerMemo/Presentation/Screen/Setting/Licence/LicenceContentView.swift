import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class LicenceContentView: UIView {
    private var body: UIView {
        VStackView(alignment: .center) {
            UILabel().configure {
                $0.text = "Hello World!"
            }
        }
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

extension LicenceContentView {}

// MARK: - private methods

private extension LicenceContentView {}

// MARK: - protocol

extension LicenceContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct LicenceContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: LicenceContentView())
        }
    }
#endif