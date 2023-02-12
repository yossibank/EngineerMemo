import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class MemoListContentView: UIView {
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )

    private var dataSource: UICollectionViewDiffableDataSource<
        MemoListSection,
        MemoItem
    >!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
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
        collectionView.register(
            MemoListHeaderView.self,
            forSupplementaryViewOfKind: "section-header-element-kind",
            withReuseIdentifier: MemoListHeaderView.className
        )

        let cellRegistration = UICollectionView.CellRegistration<
            UICollectionViewListCell,
            MemoItem
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

        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }

    func setupHeaderView() {
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            guard
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: "section-header-element-kind",
                    withReuseIdentifier: MemoListHeaderView.className,
                    for: indexPath
                ) as? MemoListHeaderView
            else {
                return .init()
            }

            header.configure(title: "title")

            return header
        }
    }

    func createLayout() -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = 56
        let headerKind = "section-header-element-kind"

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
            count: 2
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
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<
            MemoListSection,
            MemoItem
        >()
        dataSourceSnapshot.appendSections(MemoListSection.allCases)

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
    func setupViews() {
        apply([
            .addSubview(collectionView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints {
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
