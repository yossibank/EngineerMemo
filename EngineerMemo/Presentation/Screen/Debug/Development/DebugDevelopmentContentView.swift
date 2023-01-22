#if DEBUG
    import Combine
    import SnapKit
    import SwiftUI
    import UIKit

    // MARK: - stored properties & init

    final class DebugDevelopmentContentView: UIView {
        lazy var didSelectContentPublisher = didSelectContentSubject.eraseToAnyPublisher()

        private var dataSource: UITableViewDiffableDataSource<
            DebugDevelopmentSection,
            DebugDevelopmentItem
        >!

        private let didSelectContentSubject = PassthroughSubject<DebugCoreDataItem, Never>()

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

    private extension DebugDevelopmentContentView {
        func setupTableView() {
            dataSource = configureDataSource()

            tableView.registerCell(with: DebugDevelopmentCell.self)
            tableView.registerHeaderFooterView(with: TitleHeaderFooterView.self)
            tableView.separatorStyle = .none
            tableView.dataSource = dataSource
            tableView.delegate = self

            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = .zero
            }
        }

        func configureDataSource() -> UITableViewDiffableDataSource<
            DebugDevelopmentSection,
            DebugDevelopmentItem
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
            item: DebugDevelopmentItem
        ) -> UITableViewCell? {
            let cell = tableView.dequeueReusableCell(
                withType: DebugDevelopmentCell.self,
                for: indexPath
            )

            let section = DebugDevelopmentSection.allCases[indexPath.section]

            switch section {
            case .development, .coreData:
                cell.isUserInteractionEnabled = true

            default:
                cell.isUserInteractionEnabled = false
            }

            cell.configure(item: item)

            return cell
        }

        func apply() {
            var dataSourceSnapshot = NSDiffableDataSourceSnapshot<
                DebugDevelopmentSection,
                DebugDevelopmentItem
            >()

            dataSourceSnapshot.appendSections(DebugDevelopmentSection.allCases)

            DebugDevelopmentSection.allCases.forEach {
                dataSourceSnapshot.appendItems(
                    $0.items,
                    toSection: $0
                )
            }

            dataSource.apply(
                dataSourceSnapshot,
                animatingDifferences: false
            )
        }
    }

    // MARK: - delegate

    extension DebugDevelopmentContentView: UITableViewDelegate {
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
            guard let section = DebugDevelopmentSection.allCases[safe: section] else {
                return nil
            }

            let view = tableView.dequeueReusableHeaderFooterView(
                withType: TitleHeaderFooterView.self
            )

            view.configure(title: section.title)

            return view
        }

        func tableView(
            _ tableView: UITableView,
            didSelectRowAt indexPath: IndexPath
        ) {
            tableView.deselectRow(
                at: indexPath,
                animated: false
            )

            let section = DebugDevelopmentSection.allCases[indexPath.section]

            switch section {
            case .development:
                UIControl().sendAction(
                    #selector(URLSessionTask.suspend),
                    to: UIApplication.shared,
                    for: nil
                )

                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                    exit(0)
                }

            case .coreData:
                let item = DebugCoreDataItem.allCases[indexPath.row]
                didSelectContentSubject.send(item)

            default:
                break
            }
        }
    }

    // MARK: - protocol

    extension DebugDevelopmentContentView: ContentView {
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

    struct DebugDevelopmentContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugDevelopmentContentView())
        }
    }
#endif
