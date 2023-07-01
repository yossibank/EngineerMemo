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
            $0.setTitle(title: L10n.Profile.Project.title)
        }

        contentsView.configure {
            $0.setTitle(title: L10n.Profile.Project.content)
        }
    }

    private let editIcon = UIImageView().configure {
        $0.image = Asset.edit.image
            .resized(size: .init(width: 16, height: 16))
            .withRenderingMode(.alwaysOriginal)
    }

    private let titleView = TitleContentView()
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
        titleView.updateValue(modelObject.title ?? .noSetting)
        contentsView.updateValue(modelObject.content ?? .noSetting)
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
