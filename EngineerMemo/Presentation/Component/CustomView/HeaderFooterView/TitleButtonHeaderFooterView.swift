import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class TitleButtonHeaderFooterView: UITableViewHeaderFooterView {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapEditButtonPublisher = editButton.publisher(for: .touchUpInside)

    private lazy var baseView = UIView()
        .addSubview(body) {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        .addSubview(editButton) {
            $0.top.trailing.equalToSuperview().inset(8)
        }
        .configure {
            $0.backgroundColor = .primaryGray
            $0.layer.cornerRadius = 8
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

    private var body: UIView {
        VStackView(alignment: .center) {
            titleLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }
    }

    private let titleLabel = UILabel()
    private let editButton = UIButton(type: .system).configure {
        var config = UIButton.Configuration.filled()
        config.title = L10n.Components.Button.Do.edit
        config.image = Asset.profileEdit.image
            .resized(size: .init(width: 16, height: 16))
            .withRenderingMode(.alwaysOriginal)
        config.baseForegroundColor = .primary
        config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.imagePadding = 4
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 12)
            return outgoing
        }
        config.background.backgroundColor = .primaryGray
        config.background.cornerRadius = 8
        config.background.strokeColor = .primary
        config.background.strokeWidth = 1.0
        $0.configuration = config
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

extension TitleButtonHeaderFooterView {
    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension TitleButtonHeaderFooterView {
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - private methods

private extension TitleButtonHeaderFooterView {
    func setupView() {
        configure {
            $0.addSubview(baseView) {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(32)
            }

            var backgroundConfiguration = UIBackgroundConfiguration.listPlainHeaderFooter()
            backgroundConfiguration.backgroundColor = .background
            $0.backgroundConfiguration = backgroundConfiguration
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct TitleButtonHeaderFooterViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: TitleButtonHeaderFooterView())
        }
    }
#endif
