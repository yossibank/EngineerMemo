import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum ProfileListContentViewSection: CaseIterable {
    case top
    case basic
    case skill
    case project
}

enum ProfileListContentViewItem: Hashable {
    case top(ProfileModelObject?)
    case basic(ProfileModelObject?)
    case skill(SkillModelObject?)
    case project(ProjectModelObject?)
}

// MARK: - properties & init

final class ProfileListContentView: UIView {
    typealias Section = ProfileListContentViewSection
    typealias Item = ProfileListContentViewItem

    var modelObject: ProfileModelObject? {
        didSet {
            applySnapshot()
        }
    }

    private(set) lazy var didTapIconChangeButtonPublisher = didTapIconChangeButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didTapBasicSettingButtonPublisher = didTapBasicSettingButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didTapSkillSettingButtonPublisher = didTapSkillSettingButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didTapProjectCreateButtonPublisher = didTapProjectCreateButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didSelectProjectCellPublisher = didSelectProjectCellSubject.eraseToAnyPublisher()

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

    private let didTapIconChangeButtonSubject = PassthroughSubject<ProfileModelObject, Never>()
    private let didTapBasicSettingButtonSubject = PassthroughSubject<ProfileModelObject?, Never>()
    private let didTapSkillSettingButtonSubject = PassthroughSubject<ProfileModelObject, Never>()
    private let didTapProjectCreateButtonSubject = PassthroughSubject<ProfileModelObject, Never>()
    private let didSelectProjectCellSubject = PassthroughSubject<(String, ProfileModelObject), Never>()

    private let tableView = UITableView(
        frame: .zero,
        style: .grouped
    )

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

private extension ProfileListContentView {
    func setupTableView() {
        tableView.configure {
            $0.registerCells(
                with: [
                    ProfileTopCell.self,
                    ProfileBasicCell.self,
                    ProfileSkillCell.self,
                    ProfileProjectCell.self,
                    EmptyTableCell.self
                ]
            )
            $0.registerHeaderFooterView(with: TitleButtonHeaderFooterView.self)
            $0.backgroundColor = .background
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

        case let .basic(modelObject):
            guard let modelObject else {
                let cell = tableView.dequeueReusableCell(
                    withType: EmptyTableCell.self,
                    for: indexPath
                )

                cell.configure(
                    with: .init(
                        description: L10n.Profile.settingDescription,
                        buttonTitle: L10n.Components.Button.Do.setting,
                        buttonIcon: Asset.profileSetting.image
                    )
                )

                cell.didTapEmptyButtonPublisher.sink { [weak self] _ in
                    self?.didTapBasicSettingButtonSubject.send(modelObject)
                }
                .store(in: &cell.cancellables)

                return cell
            }

            let cell = tableView.dequeueReusableCell(
                withType: ProfileBasicCell.self,
                for: indexPath
            )

            cell.configure(modelObject)

            return cell

        case let .skill(modelObject):
            guard let modelObject else {
                let cell = tableView.dequeueReusableCell(
                    withType: EmptyTableCell.self,
                    for: indexPath
                )

                cell.configure(
                    with: .init(
                        description: L10n.Profile.skillDescription,
                        buttonTitle: L10n.Components.Button.Do.setting,
                        buttonIcon: Asset.profileSetting.image
                    )
                )

                cell.didTapEmptyButtonPublisher.sink { [weak self] _ in
                    guard
                        let self,
                        let modelObject = self.modelObject
                    else {
                        return
                    }

                    didTapSkillSettingButtonSubject.send(modelObject)
                }
                .store(in: &cell.cancellables)

                return cell
            }

            let cell = tableView.dequeueReusableCell(
                withType: ProfileSkillCell.self,
                for: indexPath
            )

            cell.configure(modelObject)

            return cell

        case let .project(modelObject):
            guard let modelObject else {
                let cell = tableView.dequeueReusableCell(
                    withType: EmptyTableCell.self,
                    for: indexPath
                )

                cell.configure(
                    with: .init(
                        description: L10n.Profile.projectDescription,
                        buttonTitle: L10n.Components.Button.Do.setting,
                        buttonIcon: Asset.profileSetting.image
                    )
                )

                cell.didTapEmptyButtonPublisher.sink { [weak self] _ in
                    guard
                        let self,
                        let modelObject = self.modelObject
                    else {
                        return
                    }

                    didTapProjectCreateButtonSubject.send(modelObject)
                }
                .store(in: &cell.cancellables)

                return cell
            }

            let cell = tableView.dequeueReusableCell(
                withType: ProfileProjectCell.self,
                for: indexPath
            )

            cell.configure(modelObject)

            return cell
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
            [.basic(modelObject)],
            toSection: .basic
        )

        if let modelObject {
            dataSourceSnapshot.appendItems(
                [.skill(modelObject.skill)],
                toSection: .skill
            )
        }

        if let modelObject {
            if modelObject.projects.isEmpty {
                dataSourceSnapshot.appendItems(
                    [.project(nil)],
                    toSection: .project
                )
            } else {
                modelObject.projects
                    .sorted(by: { $0.startDate ?? .init() > $1.startDate ?? .init() })
                    .forEach {
                        dataSourceSnapshot.appendItems(
                            [.project($0)],
                            toSection: .project
                        )
                    }
            }
        }

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - delegate

extension ProfileListContentView: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        switch Section.allCases[section] {
        case .top:
            return nil

        case .basic:
            guard let modelObject else {
                return nil
            }

            let view = tableView.dequeueReusableHeaderFooterView(
                withType: TitleButtonHeaderFooterView.self
            )

            view.configure(with: .basic)

            view.didTapEditButtonPublisher.sink { [weak self] _ in
                self?.didTapBasicSettingButtonSubject.send(modelObject)
            }
            .store(in: &view.cancellables)

            return view

        case .skill:
            guard let modelObject else {
                return nil
            }

            let view = tableView.dequeueReusableHeaderFooterView(
                withType: TitleButtonHeaderFooterView.self
            )

            view.configure(with: .skill)

            view.didTapEditButtonPublisher.sink { [weak self] _ in
                self?.didTapSkillSettingButtonSubject.send(modelObject)
            }
            .store(in: &view.cancellables)

            return view

        case .project:
            guard let modelObject else {
                return nil
            }

            let view = tableView.dequeueReusableHeaderFooterView(
                withType: TitleButtonHeaderFooterView.self
            )

            view.configure(with: .project)

            view.didTapEditButtonPublisher.sink { [weak self] _ in
                self?.didTapProjectCreateButtonSubject.send(modelObject)
            }
            .store(in: &view.cancellables)

            return view
        }
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        switch Section.allCases[section] {
        case .top:
            return .zero

        case .basic:
            return modelObject.isNil
                ? .zero
                : UITableView.automaticDimension

        case .skill:
            guard let modelObject else {
                return .zero
            }

            return modelObject.skill.isNil
                ? .zero
                : UITableView.automaticDimension

        case .project:
            guard let modelObject else {
                return .zero
            }

            return modelObject.projects.isEmpty
                ? .zero
                : UITableView.automaticDimension
        }
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        .init()
    }

    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        16
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: false
        )

        guard
            let modelObject,
            let identifier = modelObject.projects[safe: indexPath.row]?.identifier,
            let section = Section.allCases[safe: indexPath.section],
            section == .project
        else {
            return
        }

        didSelectProjectCellSubject.send((
            identifier,
            modelObject
        ))
    }
}

// MARK: - protocol

extension ProfileListContentView: ContentView {
    func setupView() {
        addSubview(tableView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileListContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileListContentView()) {
                $0.modelObject = ProfileModelObjectBuilder().build()
            }
        }
    }
#endif
