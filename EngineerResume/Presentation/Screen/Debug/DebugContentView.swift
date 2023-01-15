#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - section & item

    enum DebugSection: CaseIterable {
        case commitHash
        case device

        var title: String {
            switch self {
            case .commitHash:
                return L10n.Debug.commitHash

            case .device:
                return L10n.Debug.device
            }
        }
    }

    struct DebugItem: Hashable {
        let title: String
    }

    // MARK: - stored properties & init

    final class DebugContentView: UIView {
        private var dataSource: UITableViewDiffableDataSource<DebugSection, DebugItem>!

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

    // MARK: - private methods

    private extension DebugContentView {
        func setupTableView() {
            dataSource = configureDataSource()

            tableView.registerCell(with: DebugCell.self)
            tableView.registerHeaderFooterView(with: TitleHeaderFooterView.self)
            tableView.separatorStyle = .none
            tableView.dataSource = dataSource
            tableView.delegate = self

            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = .zero
            }
        }

        func configureDataSource() -> UITableViewDiffableDataSource<
            DebugSection,
            DebugItem
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
            item: DebugItem
        ) -> UITableViewCell? {
            let cell = tableView.dequeueReusableCell(
                withType: DebugCell.self,
                for: indexPath
            )

            cell.configure(title: item.title)

            return cell
        }

        func apply() {
            var dataSourceSnapshot = NSDiffableDataSourceSnapshot<DebugSection, DebugItem>()
            dataSourceSnapshot.appendSections(DebugSection.allCases)

            dataSourceSnapshot.appendItems(
                [.init(title: "コミットハッシュ値")],
                toSection: .commitHash
            )

            dataSourceSnapshot.appendItems(
                [.init(title: "DeviceID")],
                toSection: .device
            )

            dataSource.apply(
                dataSourceSnapshot,
                animatingDifferences: false
            )
        }
    }

    // MARK: - delegate

    extension DebugContentView: UITableViewDelegate {
        func tableView(
            _ tableView: UITableView,
            heightForRowAt indexPath: IndexPath
        ) -> CGFloat {
            56
        }

        func tableView(
            _ tableView: UITableView,
            heightForHeaderInSection section: Int
        ) -> CGFloat {
            28
        }

        func tableView(
            _ tableView: UITableView,
            viewForHeaderInSection section: Int
        ) -> UIView? {
            let section = DebugSection.allCases[section]
            let view = tableView.dequeueReusableHeaderFooterView(
                withType: TitleHeaderFooterView.self
            )

            view.configure(title: section.title)

            return view
        }
    }

    // MARK: - protocol

    extension DebugContentView: ContentView {
        func setupViews() {
            apply(.backgroundPrimary)
            addSubview(tableView)
        }

        func setupConstraints() {
            tableView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }

    struct DebugContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugContentView())
        }
    }
#endif
