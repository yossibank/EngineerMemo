import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum ProfileIconContentViewSection: Int, CaseIterable {
    case main
}

struct ProfileIconContentViewItem: Hashable {
    let icon: UIImage
    let title: String

    static let contents: [ProfileIconContentViewItem] = [
        .init(icon: Asset.elephant.image, title: L10n.Profile.Icon.elephant),
        .init(icon: Asset.fox.image, title: L10n.Profile.Icon.fox),
        .init(icon: Asset.octopus.image, title: L10n.Profile.Icon.octopus),
        .init(icon: Asset.panda.image, title: L10n.Profile.Icon.panda),
        .init(icon: Asset.penguin.image, title: L10n.Profile.Icon.penguin),
        .init(icon: Asset.seal.image, title: L10n.Profile.Icon.seal),
        .init(icon: Asset.sheep.image, title: L10n.Profile.Icon.sheep)
    ]
}

// MARK: - properties & init

final class ProfileIconContentView: UIView {
    typealias Section = ProfileIconContentViewSection
    typealias Item = ProfileIconContentViewItem

    private(set) lazy var didChangeIconDataPublisher = didChangeIconDataSubject.eraseToAnyPublisher()
    private(set) lazy var didChangeIconIndexPublisher = didChangeIconIndexSubject.eraseToAnyPublisher()

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )

    private lazy var dataSource = UICollectionViewDiffableDataSource<
        Section,
        Item
    >(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
        guard let self else {
            return .init()
        }

        collectionView.selectItem(
            at: .init(
                item: DataHolder.profileIcon.rawValue,
                section: Section.main.rawValue
            ),
            animated: false,
            scrollPosition: .left
        )

        return collectionView.dequeueConfiguredReusableCell(
            using: self.cellRegistration,
            for: indexPath,
            item: item
        )
    }

    private var collectionViewLayout: UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(180)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: .init(layoutSize: layoutSize),
            count: 2
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24.0

        let sideInset: CGFloat = 8.0
        section.contentInsets = .init(
            top: .zero,
            leading: sideInset,
            bottom: .zero,
            trailing: sideInset
        )

        return UICollectionViewCompositionalLayout(section: section)
    }

    private let cellRegistration = UICollectionView.CellRegistration<
        ProfileIconCell,
        Item
    > { cell, _, item in
        cell.configure(
            icon: item.icon,
            title: item.title
        )
    }

    private let didChangeIconDataSubject = PassthroughSubject<Data?, Never>()
    private let didChangeIconIndexSubject = PassthroughSubject<Int, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupCollectionView()
        applySnapshot()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

private extension ProfileIconContentView {
    func setupCollectionView() {
        collectionView.configure {
            $0.backgroundColor = .primary
            $0.delegate = self
        }
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        Item.contents.forEach {
            dataSourceSnapshot.appendItems(
                [$0],
                toSection: .main
            )
        }

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - delegate

extension ProfileIconContentView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        didChangeIconIndexSubject.send(indexPath.item)

        if let item = Item.contents[safe: indexPath.item] {
            didChangeIconDataSubject.send(item.icon.pngData())
        }
    }
}

// MARK: - protocol

extension ProfileIconContentView: ContentView {
    func setupView() {
        addSubview(collectionView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileIconContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ProfileIconContentView()
            )
        }
    }
#endif
