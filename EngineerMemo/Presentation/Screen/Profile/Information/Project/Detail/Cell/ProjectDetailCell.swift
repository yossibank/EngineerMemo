import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProjectDetailCell: UITableViewCell {
    typealias Process = ProjectModelObject.Process

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

            contentsView.configure {
                $0.setTitle(
                    title: L10n.Project.content,
                    icon: Asset.projectContent.image
                )
            }
        }
    }

    private lazy var processView: UIView = VStackView(spacing: 8) {
        HStackView(spacing: 8) {
            UIImageView()
                .addConstraint {
                    $0.size.equalTo(24)
                }
                .configure {
                    $0.image = Asset.projectProcess.image
                }

            UILabel().configure {
                $0.text = L10n.Project.process
                $0.textColor = .secondaryGray
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }

        BorderView().configure {
            $0.changeColor(.secondaryGray)
        }

        processBaseView.configure {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }

    private lazy var processBaseView = UIStackView(
        arrangedSubviews: Process.allCases.map { ProjectUpdateProcessView($0) }
    )

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

        processBaseView.subviews
            .compactMap { $0 as? ProjectUpdateProcessView }
            .forEach { $0.updateImage(modelObject.processes) }

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
