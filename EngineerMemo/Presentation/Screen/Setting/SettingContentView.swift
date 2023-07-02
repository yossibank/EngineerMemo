import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum SettingContentViewSection: CaseIterable {
    case main
}

// MARK: - properties & init

final class SettingContentView: UIView {
    typealias Section = SettingContentViewSection
    typealias Item = String

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

        return collectionView.dequeueConfiguredReusableCell(
            using: self.cellRegistration,
            for: indexPath,
            item: item
        )
    }

    private var collectionViewLayout: UICollectionViewLayout {
        let estimatedHeight: CGFloat = 56

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
        UICollectionViewListCell,
        Item
    > { cell, indexPath, item in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = item
        configuration.secondaryText = "IndexPath Row: \(indexPath.row)"
        configuration.image = .init(systemName: "appletv")

        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = indexPath.row % 2 == 0
            ? .green
            : .orange

        cell.contentConfiguration = configuration
        cell.backgroundConfiguration = backgroundConfig
    }

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

// MARK: - internal methods

extension SettingContentView {}

// MARK: - private methods

private extension SettingContentView {
    func setupCollectionView() {
        collectionView.configure {
            $0.backgroundColor = .background
        }
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        ["text1", "text2", "text3", "text4", "text5"].forEach {
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

// MARK: - protocol

extension SettingContentView: ContentView {
    func setupView() {
        addSubview(collectionView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SettingContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: SettingContentView())
        }
    }
#endif
