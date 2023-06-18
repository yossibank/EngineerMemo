import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileProjectCell: UITableViewCell {
    private lazy var baseView = UIView()
        .addSubview(projectView) {
            $0.edges.equalToSuperview().inset(16)
        }
        .configure {
            $0.backgroundColor = .primaryGray
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }

    private lazy var projectView = VStackView(
        alignment: .leading,
        spacing: 16
    ) {
        VStackView(spacing: 8) {
            UILabel().configure {
                $0.text = "案件名"
                $0.textColor = .secondaryGray
                $0.font = .systemFont(ofSize: 14)
            }

            titleLabel.configure {
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }

        VStackView(spacing: 8) {
            UILabel().configure {
                $0.text = "案件内容"
                $0.textColor = .secondaryGray
                $0.font = .systemFont(ofSize: 14)
            }

            contentLabel.configure {
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }
    }

    private let titleLabel = UILabel()
    private let contentLabel = UILabel()

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

extension ProfileProjectCell {
    func configure(_ modelObject: ProjectModelObject) {
        titleLabel.text = modelObject.title ?? .noSetting
        contentLabel.text = modelObject.content ?? .noSetting
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
