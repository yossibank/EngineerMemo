#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - section

    enum DebugSkillListContentViewSection: CaseIterable {
        case main

        var cellType: DebugSkillListCell.Type {
            DebugSkillListCell.self
        }
    }

    // MARK: - properties & init

    final class DebugSkillListContentView: UIView {
        typealias Section = DebugSkillListContentViewSection
        typealias Item = ProfileModelObject
        typealias DataSource = DebugSkillListDataSource

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

    private extension DebugSkillListContentView {
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
            let cell = tableView.dequeueReusableCell(
                withType: DebugSkillListContentViewSection.main.cellType,
                for: indexPath
            )

            cell.configure(item)

            return cell
        }
    }

    // MARK: - delegate

    extension DebugSkillListContentView: UITableViewDelegate {
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

    extension DebugSkillListContentView: ContentView {
        func setupView() {
            addSubview(tableView) {
                $0.edges.equalToSuperview()
            }
        }
    }

    // MARK: - preview

    struct DebugSkillListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugSkillListContentView()) {
                $0.dataSource.modelObject = [
                    ProfileModelObjectBuilder()
                        .skill(SKillModelObjectBuilder().build())
                        .build()
                ]
            }
        }
    }
#endif
