import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ___FILEBASENAME___: UICollectionViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private var body: UIView {
        VStackView(alignment: .center) {
            UILabel()
                .modifier(\.text, "Hello World")
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

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension ___FILEBASENAME___ {}

// MARK: - private methods

private extension ___FILEBASENAME___ {
    func setupView() {
        contentView.addSubview(body) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ___FILEBASENAME___Preview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ___FILEBASENAME___()
            )
        }
    }
#endif
