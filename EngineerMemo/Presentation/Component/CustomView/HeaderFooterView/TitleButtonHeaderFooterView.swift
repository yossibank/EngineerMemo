import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class TitleButtonHeaderFooterView: UITableViewHeaderFooterView {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var didTapEditButtonPublisher = editButton.publisher(for: .touchUpInside)

    private var body: UIView {
        HStackView {
            titleLabel.configure {
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
            }

            editButton
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
        config.background.backgroundColor = .background
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
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(32)
            }

            $0.addSubview(BorderView()) {
                $0.height.equalTo(1)
                $0.bottom.equalToSuperview().inset(-8)
                $0.horizontalEdges.equalToSuperview().inset(32)
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
