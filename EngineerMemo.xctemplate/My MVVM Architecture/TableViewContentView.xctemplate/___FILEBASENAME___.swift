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
    private var dataSource: UITableViewDiffableDataSource<
        ___FILEBASENAME___Section,
        ___FILEBASENAME___Item
    >!

    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupTableView()
        apply()
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
    func setupTableView() {
        dataSource = configureDataSource()

        tableView.registerCell(with: UITableViewCell.self)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    func configureDataSource() -> UITableViewDiffableDataSource<
        ___FILEBASENAME___Section,
        ___FILEBASENAME___Item
    > {
        .init(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else {
                return .init()
            }

            return self.makeCell(
                tableView: tableView,
                indexPath: indexPath,
                item: item
            )
        }
    }

    func makeCell(
        tableView: UITableView,
        indexPath: IndexPath,
        item: ___FILEBASENAME___Item
    ) -> UITableViewCell? {
        switch item {
        case let .main(text):
            let cell = tableView.dequeueReusableCell(
                withType: UITableViewCell.self,
                for: indexPath
            )

            var content = cell.defaultContentConfiguration()
            content.text = text
            content.secondaryText = "IndexPath Row: \(indexPath.row)"
            content.image = .init(systemName: "appletv")

            cell.contentConfiguration = content

            return cell
        }
    }

    func apply() {
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

// MARK: - delegate

extension ___FILEBASENAME___: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - protocol

extension ___FILEBASENAME___: ContentView {
    func setupViews() {
        apply([
            .addSubview(tableView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        tableView.snp.makeConstraints {
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
