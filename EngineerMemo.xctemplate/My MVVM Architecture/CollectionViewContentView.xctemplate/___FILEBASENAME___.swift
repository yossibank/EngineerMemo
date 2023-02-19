import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum ___FILEBASENAME___Section: CaseIterable {
    case main
}

enum ___FILEBASENAME___Item: Hashable {
    case main(String)
}

// MARK: - properties & init

final class ___FILEBASENAME___: UIView {
    typealias Section = ___FILEBASENAME___Section
    typealias Item = ___FILEBASENAME___Item

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )
    .modifier(\.backgroundColor, .primary)

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

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
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
    func createLayout() -> UICollectionViewLayout {
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

extension ___FILEBASENAME___: ContentView {
    func setupView() {
        addSubview(collectionView) {
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
