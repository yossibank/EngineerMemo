#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - section & item

    enum DebugProfileListContentViewSection: CaseIterable {
        case main

        var cellType: DebugProfileListCell.Type {
            DebugProfileListCell.self
        }
    }

    // MARK: - properties & init

    final class DebugProfileListContentView: UIView {
        typealias Section = DebugProfileListContentViewSection
        typealias Item = ProfileModelObject
        typealias DataSource = DebugProfileListDataSource

        private(set) lazy var didTapReloadButtonPublisher = didTapReloadButtonSubject.eraseToAnyPublisher()
        private(set) lazy var didDeletedModelObjectPublisher = dataSource.didDeletedModelObjectPublisher

        private(set) lazy var dataSource = DataSource(
            tableView: tableView
        ) { [weak self] tableView, indexPath, item in
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

        private let didTapReloadButtonSubject = PassthroughSubject<Void, Never>()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupTableView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugProfileListContentView {
        func setupTableView() {
            tableView.configure {
                $0.registerCells(with: Section.allCases.map(\.cellType))
                $0.registerHeaderFooterView(with: ImageHeaderFooterView.self)
                $0.backgroundColor = .background
                $0.allowsSelection = false
                $0.separatorStyle = .none
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

            cell.configure(item)

            return cell
        }
    }

    // MARK: - delegate

    extension DebugProfileListContentView: UITableViewDelegate {
        func tableView(
            _ tableView: UITableView,
            heightForHeaderInSection section: Int
        ) -> CGFloat {
            48
        }

        func tableView(
            _ tableView: UITableView,
            viewForHeaderInSection section: Int
        ) -> UIView? {
            let view = tableView.dequeueReusableHeaderFooterView(
                withType: ImageHeaderFooterView.self
            )

            view.configure(image: Asset.reload.image)

            view.didTapIconButtonPublisher.sink { [weak self] _ in
                self?.didTapReloadButtonSubject.send(())
            }
            .store(in: &view.cancellables)

            return view
        }
    }

    // MARK: - protocol

    extension DebugProfileListContentView: ContentView {
        func setupView() {
            addSubview(tableView) {
                $0.edges.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugProfileListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugProfileListContentView()) {
                $0.dataSource.modelObject = [
                    ProfileModelObjectBuilder().build()
                ]
            }
        }
    }
#endif
