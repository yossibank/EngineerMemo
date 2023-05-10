import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum MemoDetailContentViewSection: CaseIterable {
    case main
}

// MARK: - properties & init

final class MemoDetailContentView: UIView {
    typealias Section = MemoDetailContentViewSection
    typealias Item = MemoModelObject

    var modelObject: MemoModelObject? {
        didSet {
            applySnapshot()
        }
    }

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
        let estimatedHeight: CGFloat = 200

        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: .init(layoutSize: layoutSize),
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 32,
            leading: 32,
            bottom: .zero,
            trailing: 32
        )

        return UICollectionViewCompositionalLayout(section: section)
    }

    private let cellRegistration = UICollectionView.CellRegistration<
        MemoDetailCell,
        Item
    > { cell, _, item in
        cell.configure(item)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupCollectionView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

private extension MemoDetailContentView {
    func setupCollectionView() {
        collectionView.configure {
            $0.backgroundColor = .background
        }
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        if let modelObject {
            dataSourceSnapshot.appendItems(
                [modelObject],
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

extension MemoDetailContentView: ContentView {
    func setupView() {
        addSubview(collectionView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoDetailContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MemoDetailContentView()) {
                $0.modelObject = MemoModelObjectBuilder()
                    .title("title")
                    .content("content")
                    .build()
            }
        }
    }
#endif
