import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum ProfileDetailContentViewSection: CaseIterable {
    case top
    case main
}

enum ProfileDetailContentViewItem: Hashable {
    case top(ProfileModelObject?)
    case main(ProfileModelObject?)
}

// MARK: - properties & init

final class ProfileDetailContentView: UIView {
    typealias Section = ProfileDetailContentViewSection
    typealias Item = ProfileDetailContentViewItem

    var modelObject: ProfileModelObject? {
        didSet {
            applySnapshot()
        }
    }

    private(set) lazy var didTapIconChangeButtonPublisher = didTapIconChangeButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didTapEditButtonPublisher = didTapEditButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didTapSettingButtonPublisher = didTapSettingButtonSubject.eraseToAnyPublisher()

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

    private let didTapIconChangeButtonSubject = PassthroughSubject<ProfileModelObject, Never>()
    private let didTapEditButtonSubject = PassthroughSubject<ProfileModelObject, Never>()
    private let didTapSettingButtonSubject = PassthroughSubject<Void, Never>()

    private let tableView = UITableView()

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

private extension ProfileDetailContentView {
    func setupTableView() {
        tableView.configure {
            $0.registerCells(
                with: [
                    ProfileTopCell.self,
                    ProfileSettingCell.self,
                    ProfileBasicCell.self
                ]
            )
            $0.backgroundColor = .primary
            $0.allowsSelection = false
            $0.separatorStyle = .none
            $0.dataSource = dataSource
        }
    }

    func makeCell(
        tableView: UITableView,
        indexPath: IndexPath,
        item: Item
    ) -> UITableViewCell? {
        switch item {
        case let .top(modelObject):
            let cell = tableView.dequeueReusableCell(
                withType: ProfileTopCell.self,
                for: indexPath
            )

            cell.configure(modelObject)

            cell.didTapIconChangeButtonPublisher.sink { [weak self] _ in
                if let modelObject {
                    self?.didTapIconChangeButtonSubject.send(modelObject)
                }
            }
            .store(in: &cell.cancellables)

            return cell

        case let .main(modelObject):
            if let modelObject {
                let cell = tableView.dequeueReusableCell(
                    withType: ProfileBasicCell.self,
                    for: indexPath
                )

                cell.configure(modelObject)

                cell.didTapEditButtonPublisher.sink { [weak self] _ in
                    self?.didTapEditButtonSubject.send(modelObject)
                }
                .store(in: &cell.cancellables)

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(
                    withType: ProfileSettingCell.self,
                    for: indexPath
                )

                cell.didTapSettingButtonPublisher.sink { [weak self] _ in
                    self?.didTapSettingButtonSubject.send(())
                }
                .store(in: &cell.cancellables)

                return cell
            }
        }
    }

    func applySnapshot() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections(Section.allCases)

        dataSourceSnapshot.appendItems(
            [.top(modelObject)],
            toSection: .top
        )

        dataSourceSnapshot.appendItems(
            [.main(modelObject)],
            toSection: .main
        )

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - protocol

extension ProfileDetailContentView: ContentView {
    func setupView() {
        addSubview(tableView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileDetailContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileDetailContentView()) {
                $0.modelObject = ProfileModelObjectBuilder().build()
            }
        }
    }
#endif
