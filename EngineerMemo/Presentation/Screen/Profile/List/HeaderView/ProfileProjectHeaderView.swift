import Combine
import UIKit

// MARK: - properties & init

final class ProfileProjectHeaderView: UITableViewHeaderFooterView {
    typealias SortType = DataHolder.ProfileProjectSortType

    var cancellables = Set<AnyCancellable>()

    @Published private(set) var selectedSortType: SortType = .sort {
        didSet {
            setupSort()
        }
    }

    private(set) lazy var didTapEditButtonPublisher = editButton.publisher(for: .touchUpInside)

    private var body: UIView {
        HStackView(spacing: 4) {
            UILabel().configure {
                $0.text = L10n.Profile.project
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 16)
            }

            UIView()

            sortButton

            UIView()

            editButton
        }
    }

    private let sortButton = UIButton(type: .system).configure {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .primary
        config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 10)
            return outgoing
        }
        config.background.backgroundColor = .background
        config.background.cornerRadius = 8
        config.background.strokeColor = .primary
        config.background.strokeWidth = 1.0
        $0.configuration = config
    }

    private let editButton = UIButton(type: .system).configure {
        var config = UIButton.Configuration.filled()
        config.title = L10n.Components.Button.Do.create
        config.image = Asset.projectAdd.image
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
        setupSort()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - override methods

extension ProfileProjectHeaderView {
    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - private methods

private extension ProfileProjectHeaderView {
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

    func setupSort() {
        var actions = [UIMenuElement]()

        SortType.allCases.forEach { sortType in
            actions.append(
                UIAction(
                    title: sortType.title,
                    image: sortType.image,
                    state: sortType == selectedSortType ? .on : .off,
                    handler: { [weak self] _ in
                        self?.selectedSortType = sortType
                    }
                )
            )
        }

        sortButton.configure {
            $0.menu = .init(
                title: .empty,
                options: .displayInline,
                children: actions
            )
            $0.setTitle(
                selectedSortType.title,
                for: .normal
            )
            $0.setImage(
                selectedSortType.image
                    .resized(size: .init(width: 16, height: 16))
                    .withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            $0.showsMenuAsPrimaryAction = true
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileProjectHeaderViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileProjectHeaderView())
        }
    }
#endif
