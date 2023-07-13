import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileProjectCell: UITableViewCell {
    private lazy var baseView = UIView()
        .addSubview(projectView) {
            $0.edges.equalToSuperview().inset(16)
        }
        .addSubview(editIcon) {
            $0.top.trailing.equalToSuperview().inset(8)
        }
        .apply(.borderView)

    private lazy var projectView = VStackView(alignment: .leading, spacing: 16) {
        titleView.configure {
            $0.setTitle(title: L10n.Project.title)
        }

        periodView.configure {
            $0.setTitle(title: L10n.Project.period)
        }

        contentsView.configure {
            $0.setTitle(title: L10n.Project.content)
        }
    }

    private let editIcon = UIImageView().configure {
        $0.image = Asset.edit.image
            .resized(size: .init(width: 16, height: 16))
            .withRenderingMode(.alwaysOriginal)
    }

    private let titleView = TitleContentView()
    private let periodView = TitleSubContentView()
    private let contentsView = TitleContentView()

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

// MARK: - override methods

extension ProfileProjectCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            baseView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension ProfileProjectCell {
    func configure(_ modelObject: ProjectModelObject) {
        titleView.setContent(modelObject.title ?? .noSetting)
        contentsView.setContent(modelObject.content ?? .noSetting)
        contentsView.setContentLine(2)

        setPeriod(
            startDate: modelObject.startDate,
            endDate: modelObject.endDate
        )
    }
}

// MARK: - private methods

private extension ProfileProjectCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(baseView) {
                $0.verticalEdges.equalToSuperview().inset(16)
                $0.horizontalEdges.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .background
        }

        selectionStyle = .none
        backgroundColor = .background
    }

    func setPeriod(
        startDate: Date?,
        endDate: Date?
    ) {
        if let startDate,
           let endDate {
            periodView.setContent(L10n.Project.during(startDate.toString, endDate.toString))
            periodView.setSubTitle(startDate.periodString(end: endDate))
        } else if let startDate {
            periodView.setContent(L10n.Project.startDate(startDate.toString))
            periodView.setSubTitle(nil)
        } else if let endDate {
            periodView.setContent(L10n.Project.endDate(endDate.toString))
            periodView.setSubTitle(nil)
        } else {
            periodView.setContent(.noSetting)
            periodView.setSubTitle(nil)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileProjectCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileProjectCell()) {
                $0.configure(ProjectModelObjectBuilder().build())
            }
        }
    }
#endif
