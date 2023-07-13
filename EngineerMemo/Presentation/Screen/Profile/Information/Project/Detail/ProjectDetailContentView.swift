import Combine
import UIKit
import UIKitHelper

// MARK: - section

enum ProjectDetailContentViewSection: CaseIterable {
    case main
}

// MARK: - properties & init

final class ProjectDetailContentView: UIView {
    typealias Section = ProjectDetailContentViewSection
    typealias Item = ProjectModelObject

    var modelObject: ProjectModelObject? {
        didSet {
            applySnapshot()
        }
    }

    private lazy var dataSource = UITableViewDiffableDataSource<
        Section,
        Item
    >(tableView: tableView) { [weak self] tableView, indexPath, item in
        guard let self else {
            return .init()
        }

        return makeCell(
            tableView: tableView,
            indexPath: indexPath,
            item: item
        )
    }

    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupTableView()
        applySnapshot()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

private extension ProjectDetailContentView {
    func setupTableView() {
        tableView.configure {
            $0.registerCell(with: ProjectDetailCell.self)
            $0.backgroundColor = .background
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = dataSource
        }
    }

    func makeCell(
        tableView: UITableView,
        indexPath: IndexPath,
        item: Item
    ) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(
            withType: ProjectDetailCell.self,
            for: indexPath
        )

        cell.configure(item)

        return cell
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

extension ProjectDetailContentView: ContentView {
    func setupView() {
        addSubview(tableView) {
            $0.verticalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }

        backgroundColor = .background
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProjectDetailContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProjectDetailContentView())
        }
    }
#endif
