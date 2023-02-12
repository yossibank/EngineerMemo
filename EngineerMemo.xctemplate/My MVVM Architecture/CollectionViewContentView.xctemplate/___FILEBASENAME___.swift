import Combine
import SnapKit
import UIKit
import UIStyle

// TODO: 各セクション、アイテム(必要な場合は命名変更、別ファイルで管理)

enum ___FILEBASENAME___Section: CaseIterable {
    case main
}

enum ___FILEBASENAME___Item: Hashable {
    case main(String)
}

// MARK: - properties & init

final class ___FILEBASENAME___: UIView {
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )

    private var dataSource: UICollectionViewDiffableDataSource<
        ___FILEBASENAME___Section,
        ___FILEBASENAME___Item
    >!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupCollectionView()
        applySnapshot()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension ___FILEBASENAME___ {}

// MARK: - private methods

private extension ___FILEBASENAME___ {
    func setupCollectionView() {
        let cellRegistration = UICollectionView.CellRegistration<
            UICollectionViewListCell,
            TestContentViewItem
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

    func createLayout() -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = 56

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupLayoutSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(8.0)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0

        let sideInset: CGFloat = 8.0
        section.contentInsets = .init(
            top: .zero,
            leading: sideInset,
            bottom: .zero,
            trailing: sideInset
        )

        return UICollectionViewCompositionalLayout(section: section)
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<
            ___FILEBASENAME___Section,
            ___FILEBASENAME___Item
        >()
        dataSourceSnapshot.appendSections(___FILEBASENAME___Section.allCases)

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

extension ___FILEBASENAME___: ContentView {
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

    struct ___FILEBASENAME___Preview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ___FILEBASENAME___()
            )
        }
    }
#endif
