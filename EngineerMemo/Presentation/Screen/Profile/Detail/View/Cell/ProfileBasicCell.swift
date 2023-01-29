import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class ProfileBasicCell: UITableViewCell {
    private enum ObjectType: CaseIterable {
        case name
        case age
        case gender
        case email
        case phoneNumber
        case address
        case station

        var title: String {
            switch self {
            case .name: return L10n.Profile.name
            case .age: return L10n.Profile.age
            case .gender: return L10n.Profile.gender
            case .email: return L10n.Profile.email
            case .phoneNumber: return L10n.Profile.phoneNumber
            case .address: return L10n.Profile.address
            case .station: return L10n.Profile.station
            }
        }
    }

    private lazy var mainView = UIView(
        styles: [
            .addSubview(stackView),
            .backgroundColor(.thinGray),
            .clipsToBounds(true),
            .cornerRadius(8)
        ]
    )

    private lazy var stackView = UIStackView(
        styles: [
            .addArrangedSubviews(arrangedSubviews),
            .axis(.vertical),
            .spacing(16)
        ]
    )

    private lazy var titleStackView = UIStackView(
        styles: [
            .addArrangedSubview(basicLabel),
            .axis(.vertical),
            .alignment(.center)
        ]
    )

    private var arrangedSubviews: [UIView] {
        var subviews: [UIView] = ObjectType.allCases.map(createStackView)
        subviews.insert(titleStackView, at: 0)
        return subviews
    }

    private let basicLabel = UILabel(styles: [.text(L10n.Profile.basicInformation), .boldSystemFont(size: 16)])
    private let nameLabel = UILabel(style: .boldSystemFont(size: 16))
    private let ageLabel = UILabel(style: .boldSystemFont(size: 16))
    private let genderLabel = UILabel(style: .boldSystemFont(size: 16))
    private let emailLabel = UILabel(style: .boldSystemFont(size: 16))
    private let phoneNumberLabel = UILabel(style: .boldSystemFont(size: 16))
    private let addressLabel = UILabel(styles: [.boldSystemFont(size: 16), .numberOfLines(0)])
    private let stationLabel = UILabel(style: .boldSystemFont(size: 16))

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension ProfileBasicCell {
    func configure(_ modelObject: ProfileModelObject) {
        nameLabel.text = modelObject.name

        if let age = modelObject.birthday?.ageString() {
            ageLabel.text = age + L10n.Profile.old
        } else {
            ageLabel.text = .noSetting
        }

        genderLabel.text = modelObject.gender?.value ?? .noSetting
        emailLabel.text = modelObject.email
        phoneNumberLabel.text = modelObject.phoneNumber?.phoneText ?? .noSetting
        addressLabel.text = modelObject.address
        stationLabel.text = modelObject.station
    }
}

// MARK: - private methods

private extension ProfileBasicCell {
    func setupViews() {
        contentView.apply([
            .addSubview(mainView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        mainView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.leading.trailing.equalToSuperview().inset(32)
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }

    private func createTitleLabel(_ type: ObjectType) -> UILabel {
        let label = UILabel(styles: [.systemFont(size: 14), .textColor(.secondary)])
        label.text = type.title
        return label
    }

    private func createStackView(_ type: ObjectType) -> UIStackView {
        let stackView: UIStackView
        let valueLabel: UILabel
        let titleLabel = createTitleLabel(type)

        switch type {
        case .name:
            valueLabel = nameLabel

        case .age:
            valueLabel = ageLabel

        case .gender:
            valueLabel = genderLabel

        case .email:
            valueLabel = emailLabel

        case .phoneNumber:
            valueLabel = phoneNumberLabel

        case .address:
            valueLabel = addressLabel

        case .station:
            valueLabel = stationLabel
        }

        stackView = .init(
            styles: [
                .addArrangedSubviews([titleLabel, valueLabel]),
                .alignment(.leading),
                .axis(.vertical),
                .spacing(8)
            ]
        )

        return stackView
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
