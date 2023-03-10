import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum MemoListContentViewSection: CaseIterable {
    case main
}

enum MemoListContentViewItem: Hashable {
    case main(String)
}

// MARK: - properties & init

final class MemoListContentView: UIView {
    typealias Section = MemoListContentViewSection
    typealias Item = MemoListContentViewItem

    enum ViewType: Int {
        case one = 1
        case two
        case three
    }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )

    private lazy var dataSource = UICollectionViewDiffableDataSource<
        Section,
        Item
    >(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
        guard let self else {
            return .init()
        }

        return collectionView.dequeueConfiguredReusableCell(
            using: self.cellRegistration,
            for: indexPath,
            item: item
        )
    }

    private let cellRegistration = UICollectionView.CellRegistration<
        UICollectionViewListCell,
        Item
    > { cell, indexPath, item in
        switch item {
        case let .main(text):
            var configuration = cell.defaultContentConfiguration()
            configuration.text = text
            configuration.secondaryText = "IndexPath Row: \(indexPath.row)"
            configuration.image = .init(systemName: "appletv")

            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = indexPath.row % 2 == 0
                ? .green
                : .orange

            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = backgroundConfig
        }
    }

    private let headerRegistration = UICollectionView.SupplementaryRegistration<
        MemoListHeaderView
    > { header, _, _ in
        header.configure(title: "title")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupCollectionView()
        setupHeaderView()
        applySnapshot()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

private extension MemoListContentView {
    func setupCollectionView() {
        collectionView.configure {
            $0.registerReusableView(with: MemoListHeaderView.self)
            $0.backgroundColor = .primary
        }
    }

    func setupHeaderView() {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath in
            guard let self else {
                return .init()
            }

            let header = collectionView.dequeueConfiguredReusableSupplementary(
                using: self.headerRegistration,
                for: indexPath
            )

            header.button1Publisher
                .sink { [weak self] _ in
                    guard let self else {
                        return
                    }

                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.setCollectionViewLayout(self.createLayout(viewType: .one), animated: true)
                }
                .store(in: &header.cancellables)

            header.button2Publisher
                .sink { [weak self] _ in
                    guard let self else {
                        return
                    }

                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.setCollectionViewLayout(self.createLayout(viewType: .two), animated: true)
                }
                .store(in: &header.cancellables)

            header.button3Publisher
                .sink { [weak self] _ in
                    guard let self else {
                        return
                    }

                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.setCollectionViewLayout(self.createLayout(viewType: .three), animated: true)
                }
                .store(in: &header.cancellables)

            return header
        }
    }

    func createLayout(viewType: ViewType = .two) -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = 56
        let headerKind = String(describing: MemoListHeaderView.self)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: viewType.rawValue
        )
        group.interItemSpacing = .fixed(8.0)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0

        let topInset: CGFloat = 12.0
        let sideInset: CGFloat = 8.0
        section.contentInsets = .init(
            top: topInset,
            leading: sideInset,
            bottom: .zero,
            trailing: sideInset
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: headerKind,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        ["text1", "text2", "text3", "text4", "text5"].forEach {
            dataSourceSnapshot.appendItems([.main($0)], toSection: .main)
        }

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - protocol

extension MemoListContentView: ContentView {
    func setupView() {
        addSubview(collectionView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: MemoListContentView()
            )
        }
    }
#endif
