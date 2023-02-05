import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class ProfileBasicCell: UITableViewCell {
    var cancellables: Set<AnyCancellable> = .init()

    private(set) lazy var editButtonPublisher = editButton.publisher(for: .touchUpInside)

    private lazy var mainView = UIView(
        styles: [
            .addSubviews([stackView, editButton]),
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
        var subviews: [UIView] = ProfileContentType.allCases.map(createStackView)
        subviews.insert(titleStackView, at: 0)
        return subviews
    }

    private let editButton = UIButton(
        styles: UIStyle.edit(
            title: L10n.Components.Button.edit,
            image: ImageResources.edit
        )
    )

    private let basicLabel = UILabel(styles: [.text(L10n.Profile.basicInformation), .boldSystemFont(size: 16)])
    private let nameLabel = UILabel(style: .boldSystemFont(size: 16))
    private let ageLabel = UILabel(style: .boldSystemFont(size: 16))
    private let genderLabel = UILabel(style: .boldSystemFont(size: 16))
    private let emailLabel = UILabel(styles: [.boldSystemFont(size: 16), .numberOfLines(0)])
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

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }
}

// MARK: - internal methods

extension ProfileBasicCell {
    func configure(_ modelObject: ProfileModelObject) {
        nameLabel.apply(.text(modelObject.name))

        if let age = modelObject.birthday?.ageString() {
            ageLabel.apply(.text(age + L10n.Profile.old))
        } else {
            ageLabel.apply(.text(.noSetting))
        }

        genderLabel.apply(.text(modelObject.gender?.value ?? .noSetting))
        emailLabel.apply(.text(modelObject.email))
        phoneNumberLabel.apply(.text(modelObject.phoneNumber?.phoneText ?? .noSetting))
        addressLabel.apply(.text(modelObject.address))
        stationLabel.apply(.text(modelObject.station))
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

        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(8)
        }
    }

    private func createTitleLabel(_ type: ProfileContentType) -> UILabel {
        .init(
            styles: [
                .systemFont(size: 14),
                .text(type.title),
                .textColor(.secondary)
            ]
        )
    }

    private func createStackView(_ type: ProfileContentType) -> UIStackView {
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
