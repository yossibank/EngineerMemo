import Combine
import UIKit
import UIKitHelper

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
        roleView.setContent(modelObject.role ?? .noSetting)
        contentsView.setContent(modelObject.content ?? .noSetting)

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
