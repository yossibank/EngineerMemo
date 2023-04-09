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

    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system)
        .addConstraint {
            $0.size.equalTo(32)
        }
        .configure {
            $0.setImage(
                Asset.memoEdit.image
                    .resized(size: .init(width: 32, height: 32))
                    .withRenderingMode(.alwaysOriginal),
                for: .normal
            )
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

    private let modelObject: MemoModelObject

    init(modelObject: MemoModelObject) {
        self.modelObject = modelObject

        super.init(frame: .zero)

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

private extension MemoDetailContentView {
    func setupCollectionView() {
        collectionView.configure {
            $0.backgroundColor = .primary
        }
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        dataSourceSnapshot.appendItems(
            [modelObject],
            toSection: .main
        )

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
            WrapperView(
                view: MemoDetailContentView(
                    modelObject: MemoModelObjectBuilder()
                        .title("title")
                        .content("content")
                        .build()
                )
            )
        }
    }
#endif
