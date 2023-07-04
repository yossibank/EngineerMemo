import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum SettingContentViewSection: CaseIterable {
    case colorTheme
    case application
}

enum SettingContentViewItem: Hashable {
    case colorTheme
    case application(Application)

    enum Application: CaseIterable {
        case version
        case review
        case licence

        var title: String {
            switch self {
            case .version: return L10n.Setting.applicationVersion
            case .review: return L10n.Setting.review
            case .licence: return L10n.Setting.licence
            }
        }
    }
}

// MARK: - properties & init

final class SettingContentView: UIView {
    typealias Section = SettingContentViewSection
    typealias Item = SettingContentViewItem

    private(set) lazy var didChangeColorThemeIndexPublisher = didChangeColorThemeIndexSubject.eraseToAnyPublisher()
    private(set) lazy var didTapReviewCellPublisher = didTapReviewCellSubject.eraseToAnyPublisher()
    private(set) lazy var didTapLicenceCellPublisher = didTapLicenceCellSubject.eraseToAnyPublisher()

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
        case .application:
            return collectionView.dequeueConfiguredReusableCell(
                using: applicationCellRegistration,
                for: indexPath,
                item: item
            )

        case .colorTheme:
            let cell = collectionView.dequeueReusableCell(
                withType: SettingColorThemeCell.self,
                for: indexPath
            )

            cell.segmentIndexPublisher.sink { [weak self] in
                self?.didChangeColorThemeIndexSubject.send($0)
            }
            .store(in: &cell.cancellables)

            return cell
        }
    }

    private var collectionViewLayout: UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: .init(layoutSize: layoutSize),
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0
        section.contentInsets = .init(
            top: 8,
            leading: 16,
            bottom: 36,
            trailing: 16
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(24)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: TitleHeaderView.className,
            alignment: .top
        )
        header.pinToVisibleBounds = true

        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }

    private let applicationCellRegistration = UICollectionView.CellRegistration<
        SettingTitleContentCell,
        Item
    > { cell, _, item in
        if case let .application(item) = item {
            cell.setTitle(item.title)

            switch item {
            case .version:
                cell.updateValue(AppConfig.applicationVersion)
                cell.showDisclosure(false)

            case .review:
                cell.showDisclosure(true)

            case .licence:
                cell.showDisclosure(true)
            }
        }
    }

    private let headerRegistration = UICollectionView.SupplementaryRegistration<
        TitleHeaderView
    > { _, _, _ in }

    private let didChangeColorThemeIndexSubject = PassthroughSubject<Int, Never>()
    private let didTapReviewCellSubject = PassthroughSubject<Void, Never>()
    private let didTapLicenceCellSubject = PassthroughSubject<Void, Never>()

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

private extension SettingContentView {
    func setupCollectionView() {
        collectionView.configure {
            $0.registerCells(
                with: [
                    SettingTitleContentCell.self,
                    SettingColorThemeCell.self
                ]
            )
            $0.backgroundColor = .background
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

            switch Section.allCases[indexPath.section] {
            case .application:
                headerView.configure(with: L10n.Setting.application)

            case .colorTheme:
                headerView.configure(with: L10n.Setting.colorTheme)
            }

            return headerView
        }
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        dataSourceSnapshot.appendItems(
            [.colorTheme],
            toSection: .colorTheme
        )

        Item.Application.allCases.forEach {
            dataSourceSnapshot.appendItems(
                [.application($0)],
                toSection: .application
            )
        }

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - delegate

extension SettingContentView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard
            let section = Section.allCases[safe: indexPath.section],
            let item = Item.Application.allCases[safe: indexPath.row],
            section == .application
        else {
            return
        }

        switch item {
        case .review:
            didTapReviewCellSubject.send(())

        case .licence:
            didTapLicenceCellSubject.send(())

        default:
            break
        }
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
