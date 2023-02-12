import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class ___FILEBASENAME___: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupViews()
        setupConstraints()
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
    func setupViews() {}
    func setupConstraints() {}
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