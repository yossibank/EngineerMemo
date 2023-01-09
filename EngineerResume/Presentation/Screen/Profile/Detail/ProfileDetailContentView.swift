import Combine
import SnapKit
import UIKit

// MARK: - section & item

enum ProfileDetailSection: CaseIterable {
    case top
    case main
}

enum ProfileDetailItem: Hashable {
    case top(ProfileModelObject?)
    case main(ProfileModelObject?)
}

// MARK: - stored properties & init

final class ProfileDetailContentView: UIView {
    var modelObject: ProfileModelObject? {
        didSet {
            apply()
        }
    }

    private(set) lazy var didTapSettingButtonPublisher = didTapSettingButtonSubject.eraseToAnyPublisher()

    private var dataSource: UITableViewDiffableDataSource<ProfileDetailSection, ProfileDetailItem>!

    private let didTapSettingButtonSubject = PassthroughSubject<Void, Never>()
    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
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
        dataSource = configureDataSource()

        tableView.registerCells(
            with: [
                ProfileTopCell.self,
                ProfileNoSettingCell.self
            ]
        )

        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    func apply() {
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<ProfileDetailSection, ProfileDetailItem>()
        dataSourceSnapshot.appendSections(ProfileDetailSection.allCases)
        dataSourceSnapshot.appendItems([.top(modelObject)], toSection: .top)
        dataSourceSnapshot.appendItems([.main(modelObject)], toSection: .main)

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }

    func configureDataSource() -> UITableViewDiffableDataSource<
        ProfileDetailSection,
        ProfileDetailItem
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
        item: ProfileDetailItem
    ) -> UITableViewCell? {
        switch item {
        case let .top(modelObject):
            let cell = tableView.dequeueReusableCell(
                withType: ProfileTopCell.self,
                for: indexPath
            )

            cell.configure(modelObject)

            return cell

        case .main:
            let cell = tableView.dequeueReusableCell(
                withType: ProfileNoSettingCell.self,
                for: indexPath
            )

            cell.settingButtonTapPublisher.sink { [weak self] _ in
                self?.didTapSettingButtonSubject.send(())
            }
            .store(in: &cell.cancellables)

            return cell
        }
    }
}

// MARK: - delegate

extension ProfileDetailContentView: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch ProfileDetailSection.allCases[indexPath.section] {
        case .top:
            return UITableView.automaticDimension

        case .main:
            return 200
        }
    }
}

// MARK: - protocol

extension ProfileDetailContentView: ContentView {
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

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileDetailContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileDetailContentView()) { view in
                view.modelObject = nil
            }
        }
    }
#endif
