import Combine
import UIKit

// MARK: - section & item

enum MemoListContentViewSection: CaseIterable {
    case main
}

enum MemoListContentViewItem: Hashable {
    case list(MemoModelObject)
    case empty
}

// MARK: - properties & init

final class MemoListContentView: UIView {
    typealias Section = MemoListContentViewSection
    typealias Item = MemoListContentViewItem

    var modelObject: MemoListViewModel.ModelObject? {
        didSet {
            applySnapshot()
        }
    }

    private(set) lazy var didChangeSortPublisher = didChangeSortSubject.eraseToAnyPublisher()
    private(set) lazy var didChangeCategoryPublisher = didChangeCategorySubject.eraseToAnyPublisher()
    private(set) lazy var didTapUpdateButtonPublisher = didTapUpdateButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didSelectContentPublisher = didSelectContentSubject.eraseToAnyPublisher()

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

        switch item {
        case .list:
            return collectionView.dequeueConfiguredReusableCell(
                using: listCellRegistration,
                for: indexPath,
                item: item
            )

        case .empty:
            let cell = collectionView.dequeueReusableCell(
                withType: EmptyCollectionCell.self,
                for: indexPath
            )

            cell.configure(
                with: .init(
                    description: L10n.Memo.emptyDescription,
                    buttonTitle: L10n.Components.Button.Do.create,
                    buttonIcon: Asset.memoAdd.image
                )
            )

            cell.didTapEmptyButtonPublisher.weakSink(
                with: self,
                cancellables: &cell.cancellables
            ) {
                $0.didTapUpdateButtonSubject.send(())
            }

            return cell
        }
    }

    private var collectionViewLayout: UICollectionViewLayout {
        let estimatedHeight: CGFloat = 120

        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: .init(layoutSize: layoutSize),
            count: 1
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

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(72)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: MemoListHeaderView.className,
            alignment: .top
        )
        header.pinToVisibleBounds = true

        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }

    private var headerView: MemoListHeaderView?

    private let emptyView = UILabel().configure {
        $0.text = L10n.Memo.emptyResult
        $0.textColor = .primary
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 12)
    }

    private let listCellRegistration = UICollectionView.CellRegistration<
        MemoListCell,
        Item
    > { cell, _, item in
        if case let .list(modelObject) = item {
            cell.configure(modelObject)
        }
    }

    private let headerRegistration = UICollectionView.SupplementaryRegistration<
        MemoListHeaderView
    > { _, _, _ in }

    private let didChangeSortSubject = PassthroughSubject<MemoListSortType, Never>()
    private let didChangeCategorySubject = PassthroughSubject<MemoListCategoryType, Never>()
    private let didTapUpdateButtonSubject = PassthroughSubject<Void, Never>()
    private let didSelectContentSubject = PassthroughSubject<MemoModelObject, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupCollectionView()
        setupHeaderView()
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
            $0.registerCell(with: EmptyCollectionCell.self)
            $0.backgroundColor = .background
            $0.backgroundView = emptyView
            $0.backgroundView?.isHidden = true
            $0.delegate = self
        }
    }

    func setupHeaderView() {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath in
            guard let self else {
                return .init()
            }

            let headerView = collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )

            headerView.cancellables.formUnion([
                headerView.$selectedSortType.weakSink(with: self) {
                    $0.didChangeSortSubject.send($1)
                },
                headerView.$selectedCategoryType.weakSink(with: self) {
                    $0.didChangeCategorySubject.send($1)
                }
            ])

            self.headerView = headerView
            self.headerView?.isHidden = true

            return headerView
        }
    }

    func applySnapshot() {
        guard let modelObject else {
            return
        }

        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        if modelObject.isMemoEmpty {
            dataSourceSnapshot.appendItems(
                [.empty],
                toSection: .main
            )
        } else {
            for outputObject in modelObject.outputObjects {
                dataSourceSnapshot.appendItems(
                    [.list(outputObject)],
                    toSection: .main
                )
            }
        }

        headerView?.isHidden = modelObject.isMemoEmpty
        collectionView.backgroundView?.isHidden = modelObject.isMemoEmpty || !modelObject.isResultEmpty

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - delegate

extension MemoListContentView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(
            at: indexPath,
            animated: false
        )

        guard let modelObject = modelObject?.outputObjects[safe: indexPath.item] else {
            return
        }

        didSelectContentSubject.send(modelObject)
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
            WrapperView(view: MemoListContentView())
        }
    }
#endif
