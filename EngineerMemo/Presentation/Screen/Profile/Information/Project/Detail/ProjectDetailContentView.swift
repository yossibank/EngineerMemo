import Combine
import UIKit
import UIKitHelper

// MARK: - section

enum ProjectDetailContentViewSection: CaseIterable {
    case main

    var cellType: UITableViewCell.Type {
        switch self {
        case .main:
            return UITableViewCell.self
        }
    }
}

// MARK: - properties & init

final class ProjectDetailContentView: UIView {
    typealias Section = ProjectDetailContentViewSection
    typealias Item = String

    private lazy var dataSource = UITableViewDiffableDataSource<
        Section,
        Item
    >(tableView: tableView) { [weak self] tableView, indexPath, item in
        guard let self else {
            return .init()
        }

        return self.makeCell(
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

// MARK: - internal methods

extension ProjectDetailContentView {}

// MARK: - private methods

private extension ProjectDetailContentView {
    func setupTableView() {
        tableView.configure {
            $0.registerCells(with: Section.allCases.map(\.cellType))
            $0.backgroundColor = .background
            $0.delegate = self
            $0.dataSource = dataSource
        }
    }

    func makeCell(
        tableView: UITableView,
        indexPath: IndexPath,
        item: Item
    ) -> UITableViewCell? {
        let cellType = Section.allCases[indexPath.section].cellType

        let cell = tableView.dequeueReusableCell(
            withType: cellType,
            for: indexPath
        )

        var content = cell.defaultContentConfiguration()
        content.text = item
        content.secondaryText = "IndexPath Row: \(indexPath.row)"
        content.image = .init(systemName: "appletv")
        cell.contentConfiguration = content

        return cell
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

// MARK: - delegate

extension ProjectDetailContentView: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: false
        )
    }
}

// MARK: - protocol

extension ProjectDetailContentView: ContentView {
    func setupView() {
        addSubview(tableView) {
            $0.edges.equalToSuperview()
        }
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
