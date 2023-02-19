import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ___FILEBASENAME___: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private var body: UIView {
        VStackView(alignment: .center) {
            UILabel()
                .modifier(\.text, "Hello World")
        }
    }

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        contentView.modifier(\.backgroundColor, .primary)

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
            WrapperView(view: ___FILEBASENAME___())
        }
    }
#endif
