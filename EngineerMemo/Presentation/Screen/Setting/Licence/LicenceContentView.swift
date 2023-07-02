import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class LicenceContentView: UIView {
    private var body: UIView {
        VStackView {
            UITextView().configure {
                $0.text = AppConfig.acknowledgements
                $0.textColor = .primary
                $0.font = .italicSystemFont(ofSize: 12)
                $0.backgroundColor = .background
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

// MARK: - protocol

extension LicenceContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview().inset(24)
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
