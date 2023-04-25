import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileSkillCell: UITableViewCell {
    private lazy var baseView = UIView()
        .addSubview(body) {
            $0.edges.equalToSuperview().inset(16)
        }
        .configure {
            $0.backgroundColor = .thinGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }

    private var body: UIView {
        VStackView(alignment: .center) {
            skillLabel.configure {
                $0.text = "経験・スキル"
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }
    }

    private let skillLabel = UILabel()

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

extension ProfileSkillCell {}

// MARK: - private methods

private extension ProfileSkillCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(baseView) {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(32)
            }

            $0.backgroundColor = .primary
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileSkillCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileSkillCell())
        }
    }
#endif
