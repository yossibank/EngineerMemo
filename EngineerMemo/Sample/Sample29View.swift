import UIKit

// MARK: - properties & init

final class Sample29View: UIView {
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

extension Sample29View {}

// MARK: - private methods

private extension Sample29View {
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

    struct Sample29ViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: Sample29View())
        }
    }
#endif
