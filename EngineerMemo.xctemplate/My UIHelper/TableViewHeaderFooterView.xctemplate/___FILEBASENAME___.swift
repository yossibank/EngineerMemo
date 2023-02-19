import UIKit
import UIKitHelper

// MARK: - properties & init

final class ___FILEBASENAME___: UITableViewHeaderFooterView {
    private var body: UIView {
        VStackView(alignment: .center) {
            UILabel()
                .modifier(\.text, "Hello World")
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension ___FILEBASENAME___ {}

// MARK: - private methods

private extension ___FILEBASENAME___ {
    func setupView() {
        modifier(\.backgroundColor, .primary)

        addSubview(body) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ___FILEBASENAME___Preview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ___FILEBASENAME___())
        }
    }
#endif
