import Combine
import UIKit

// MARK: - properties & init

final class ProfileBasicCell: AllyTableViewCell {
    private lazy var baseView = UIView()
        .addSubview(basicView) {
            $0.edges.equalToSuperview().inset(16)
        }
        .apply(.borderView)

    private lazy var basicView = VStackView(alignment: .leading, spacing: 16) {
        nameView.configure {
            $0.setTitle(title: L10n.Profile.name)
        }

        ageView.configure {
            $0.setTitle(title: L10n.Profile.age)
        }

        genderView.configure {
            $0.setTitle(title: L10n.Profile.gender)
        }

        emailView.configure {
            $0.setTitle(title: L10n.Profile.email)
        }

        phoneNumberView.configure {
            $0.setTitle(title: L10n.Profile.phoneNumber)
        }

        addressView.configure {
            $0.setTitle(title: L10n.Profile.address)
        }

        stationView.configure {
            $0.setTitle(title: L10n.Profile.station)
        }
    }

    private let nameView = TitleContentView()
    private let ageView = TitleContentView()
    private let genderView = TitleContentView()
    private let emailView = TitleContentView()
    private let phoneNumberView = TitleContentView()
    private let addressView = TitleContentView()
    private let stationView = TitleContentView()

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
}

// MARK: - override methods

extension ProfileBasicCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            baseView.layer.borderColor = UIColor.primary.cgColor
        }
    }
}

// MARK: - internal methods

extension ProfileBasicCell {
    func configure(_ modelObject: ProfileModelObject) {
        nameView.setContent(modelObject.name)
        genderView.setContent(modelObject.gender?.value)
        emailView.setContent(modelObject.email)
        phoneNumberView.setContent(modelObject.phoneNumber?.phoneText)
        addressView.setContent(modelObject.address)
        stationView.setContent(modelObject.station)

        if let age = modelObject.birthday?.ageString() {
            ageView.setContent("\(age)\(L10n.Profile.old)")
        } else {
            ageView.setContent(.noSetting)
        }
    }
}

// MARK: - private methods

private extension ProfileBasicCell {
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

    struct ProfileBasicCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileBasicCell()) {
                $0.configure(ProfileModelObjectBuilder().build())
            }
        }
    }
#endif
