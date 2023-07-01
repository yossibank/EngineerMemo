import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProjectDetailCell: UITableViewCell {
    private var body: UIView {
        VStackView(spacing: 32) {
            titleView.configure {
                $0.inputValue(
                    title: L10n.Profile.Project.title,
                    icon: Asset.projectTitle.image
                )
            }

            contentsView.configure {
                $0.inputValue(
                    title: L10n.Profile.Project.content,
                    icon: Asset.projectContent.image
                )
            }
        }
    }

    private let titleView = DetailTitleView()
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
        titleView.updateValue(modelObject.title ?? .noSetting)
        contentsView.updateValue(modelObject.content ?? .noSetting)
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
