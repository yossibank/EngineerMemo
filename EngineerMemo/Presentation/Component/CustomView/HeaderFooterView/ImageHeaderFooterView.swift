import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ImageHeaderFooterView: UITableViewHeaderFooterView {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapIconButtonPublisher = iconButton.publisher(for: .touchUpInside)

    private let iconButton = UIButton(type: .system).addConstraint {
        $0.size.equalTo(32)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - override methods

extension ImageHeaderFooterView {
    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension ImageHeaderFooterView {
    func configure(image: UIImage) {
        iconButton.setImage(
            image
                .resized(size: .init(width: 32, height: 32))
                .withRenderingMode(.alwaysOriginal),
            for: .normal
        )
    }
}

// MARK: - private methods

private extension ImageHeaderFooterView {
    func setupView() {
        contentView.configure {
            $0.addSubview(iconButton) {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(32)
            }
        }

        configure {
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainHeaderFooter()
            backgroundConfiguration.backgroundColor = .background
            $0.backgroundConfiguration = backgroundConfiguration
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ImageHeaderFooterViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ImageHeaderFooterView()) {
                $0.configure(image: Asset.reload.image)
            }
        }
    }
#endif
