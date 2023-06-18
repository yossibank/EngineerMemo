import Combine
import UIKit
import UIKitHelper

// MARK: - section & item

enum ProfileDetailContentViewSection: CaseIterable {
    case top
    case basic
    case skill
}

enum ProfileDetailContentViewItem: Hashable {
    case top(ProfileModelObject?)
    case basic(ProfileModelObject?)
    case skill(SkillModelObject?)
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
    private(set) lazy var didTapBasicEditButtonPublisher = didTapBasicEditButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didTapBasicSettingButtonPublisher = didTapBasicSettingButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didTapSkillEditButtonPublisher = didTapSkillEditButtonSubject.eraseToAnyPublisher()
    private(set) lazy var didTapSkillSettingButtonPublisher = didTapSkillSettingButtonSubject.eraseToAnyPublisher()

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
    private let didTapBasicEditButtonSubject = PassthroughSubject<ProfileModelObject?, Never>()
    private let didTapBasicSettingButtonSubject = PassthroughSubject<ProfileModelObject?, Never>()
    private let didTapSkillEditButtonSubject = PassthroughSubject<ProfileModelObject, Never>()
    private let didTapSkillSettingButtonSubject = PassthroughSubject<ProfileModelObject, Never>()

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

private extension ProfileDetailContentView {
    func setupTableView() {
        tableView.configure {
            $0.registerCells(
                with: [
                    ProfileTopCell.self,
                    ProfileBasicCell.self,
                    ProfileSkillCell.self,
                    ProfileNoSettingCell.self
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
                    withType: ProfileNoSettingCell.self,
                    for: indexPath
                )

                cell.configure(with: L10n.Profile.settingDescription)

                cell.didTapSettingButtonPublisher.sink { [weak self] _ in
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
                    withType: ProfileNoSettingCell.self,
                    for: indexPath
                )

                cell.configure(with: L10n.Profile.skillDescription)

                cell.didTapSettingButtonPublisher.sink { [weak self] _ in
                    guard
                        let self,
                        let modelObject = self.modelObject
                    else {
                        return
                    }

                    self.didTapSkillSettingButtonSubject.send(modelObject)
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

        dataSource.apply(
            dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

// MARK: - delegate

extension ProfileDetailContentView: UITableViewDelegate {
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

            view.configure(with: L10n.Profile.basicInformation)

            view.didTapEditButtonPublisher.sink { [weak self] _ in
                self?.didTapBasicEditButtonSubject.send(modelObject)
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

            view.configure(with: L10n.Profile.experienceSkill)

            view.didTapEditButtonPublisher.sink { [weak self] _ in
                self?.didTapSkillEditButtonSubject.send(modelObject)
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
            return modelObject.isNil ? .zero : UITableView.automaticDimension

        case .skill:
            guard let modelObject else {
                return .zero
            }

            return modelObject.skill.isNil ? .zero : UITableView.automaticDimension
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
