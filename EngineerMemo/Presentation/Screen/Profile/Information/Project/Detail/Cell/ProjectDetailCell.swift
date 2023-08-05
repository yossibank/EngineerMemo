import Combine
import UIKit

// MARK: - properties & init

final class ProjectDetailCell: UITableViewCell {
    private var body: UIView {
        VStackView(spacing: 32) {
            titleView.configure {
                $0.setTitle(
                    title: L10n.Project.title,
                    icon: Asset.projectTitle.image
                )
            }

            periodView.configure {
                $0.setTitle(
                    title: L10n.Project.period,
                    icon: Asset.projectPeriod.image
                )
            }

            roleView.configure {
                $0.setTitle(
                    title: L10n.Project.role,
                    icon: Asset.projectRole.image
                )
            }

            processView

            languageView.configure {
                $0.setTitle(
                    title: L10n.Project.language,
                    icon: Asset.projectLanguage.image
                )
            }

            databaseView.configure {
                $0.setTitle(
                    title: L10n.Project.database,
                    icon: Asset.projectDatabase.image
                )
            }

            serverOSView.configure {
                $0.setTitle(
                    title: L10n.Project.serverOS,
                    icon: Asset.projectServerOS.image
                )
            }

            toolsView

            contentsView.configure {
                $0.setTitle(
                    title: L10n.Project.content,
                    icon: Asset.projectContent.image
                )
            }
        }
    }

    private let titleView = DetailTitleView()
    private let periodView = DetailTitleView()
    private let roleView = DetailTitleView()
    private let processView = ProfileDetailProcessView()
    private let languageView = DetailTitleView()
    private let databaseView = DetailTitleView()
    private let serverOSView = DetailTitleView()
    private let toolsView = ProfileDetailToolsView()
    private let contentsView = DetailTitleView()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension ProjectDetailCell {
    func configure(_ modelObject: ProjectModelObject) {
        titleView.setContent(modelObject.title ?? .noSetting)
        contentsView.setContent(modelObject.content ?? .noSetting)

        if let role = modelObject.role {
            roleView.setContent(role)
        }

        if let language = modelObject.language {
            languageView.setContent(language)
        }

        if let database = modelObject.database {
            databaseView.setContent(database)
        }

        if let serverOS = modelObject.serverOS {
            serverOSView.setContent(serverOS)
        }

        processView.configure(modelObject.processes)
        toolsView.configure(modelObject.tools)
        roleView.isHidden = modelObject.role.isNil
        languageView.isHidden = modelObject.language.isNil
        databaseView.isHidden = modelObject.database.isNil
        serverOSView.isHidden = modelObject.serverOS.isNil
        toolsView.isHidden = modelObject.tools.isEmpty

        setPeriod(
            startDate: modelObject.startDate,
            endDate: modelObject.endDate
        )
    }
}

// MARK: - private methods

private extension ProjectDetailCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
            }

            $0.backgroundColor = .background
        }
    }

    func setPeriod(
        startDate: Date?,
        endDate: Date?
    ) {
        if let startDate,
           let endDate {
            periodView.setContent(L10n.Project.during(startDate.toString, endDate.toString))
        } else if let startDate {
            periodView.setContent(L10n.Project.startDate(startDate.toString))
        } else if let endDate {
            periodView.setContent(L10n.Project.endDate(endDate.toString))
        } else {
            periodView.setContent(.noSetting)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProjectDetailCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProjectDetailCell())
        }
    }
#endif
