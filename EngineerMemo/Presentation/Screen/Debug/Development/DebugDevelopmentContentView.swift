#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - section & item

    enum DebugDevelopmentContentViewSection: CaseIterable {
        case git
        case device
        case development
        case coreData

        var cellType: DebugDevelopmentCell.Type {
            DebugDevelopmentCell.self
        }

        var title: String {
            switch self {
            case .git: return L10n.Debug.Section.git
            case .device: return L10n.Debug.Section.device
            case .development: return L10n.Debug.Section.development
            case .coreData: return L10n.Debug.Section.coreData
            }
        }

        var items: [DebugDevelopmentContentViewItem] {
            switch self {
            case .git:
                return [
                    .init(title: L10n.Debug.Git.commitHash, subTitle: Git.commitHash)
                ]

            case .device:
                return [
                    .init(title: L10n.Debug.Device.version, subTitle: UIDevice.current.systemVersion),
                    .init(title: L10n.Debug.Device.name, subTitle: UIDevice.current.name),
                    .init(title: L10n.Debug.Device.udid, subTitle: UIDevice.deviceId)
                ]

            case .development:
                return [
                    .init(title: L10n.Debug.Development.shutdown)
                ]

            case .coreData:
                return [
                    .init(title: L10n.Debug.CoreData.list),
                    .init(title: L10n.Debug.CoreData.create),
                    .init(title: L10n.Debug.CoreData.update)
                ]
            }
        }
    }

    struct DebugDevelopmentContentViewItem: Hashable {
        var title: String
        var subTitle: String?
    }

    // MARK: - enum

    enum DebugCoreDataAction: CaseIterable {
        case list
        case create
        case update
    }

    // MARK: - properties & init

    final class DebugDevelopmentContentView: UIView {
        typealias Section = DebugDevelopmentContentViewSection
        typealias Item = DebugDevelopmentContentViewItem

        lazy var didSelectContentPublisher = didSelectContentSubject.eraseToAnyPublisher()

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

        private let didSelectContentSubject = PassthroughSubject<DebugCoreDataAction, Never>()

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

    private extension DebugDevelopmentContentView {
        func setupTableView() {
            tableView.configure {
                $0.registerCells(with: Section.allCases.map(\.cellType))
                $0.registerHeaderFooterView(with: TitleHeaderFooterView.self)
                $0.backgroundColor = .primary
                $0.separatorStyle = .none
                $0.delegate = self
                $0.dataSource = dataSource

                if #available(iOS 15.0, *) {
                    $0.sectionHeaderTopPadding = .zero
                }
            }
        }

        func makeCell(
            tableView: UITableView,
            indexPath: IndexPath,
            item: Item
        ) -> UITableViewCell? {
            let section = Section.allCases[indexPath.section]
            let cellType = section.cellType

            let cell = tableView.dequeueReusableCell(
                withType: cellType,
                for: indexPath
            )

            switch section {
            case .development, .coreData:
                cell.isUserInteractionEnabled = true

            default:
                cell.isUserInteractionEnabled = false
            }

            cell.configure(item: item)

            return cell
        }

        func applySnapshot() {
            var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            dataSourceSnapshot.appendSections(Section.allCases)

            Section.allCases.forEach {
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
            guard let section = Section.allCases[safe: section] else {
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

            let section = Section.allCases[indexPath.section]

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
                let action = DebugCoreDataAction.allCases[indexPath.row]
                didSelectContentSubject.send(action)

            default:
                break
            }
        }
    }

    // MARK: - protocol

    extension DebugDevelopmentContentView: ContentView {
        func setupView() {
            addSubview(tableView) {
                $0.edges.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugDevelopmentContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugDevelopmentContentView())
        }
    }
#endif
