import Foundation

struct ProfileModelObject: Hashable {
    var address: String?
    var birthday: Date?
    var email: String?
    var gender: Gender?
    var iconImage: Data?
    var name: String?
    var phoneNumber: String?
    var station: String?
    var skill: SkillModelObject?
    var identifier: String

    enum Gender: Int {
        case man
        case woman
        case other
        case noSetting

        var value: String {
            switch self {
            case .man: return L10n.Profile.Gender.man
            case .woman: return L10n.Profile.Gender.woman
            case .other: return L10n.Profile.Gender.other
            case .noSetting: return .noSetting
            }
        }
    }
}

extension ProfileModelObject {
    func basicInsert(
        _ profile: Profile,
        isNew: Bool
    ) {
        profile.address = address
        profile.birthday = birthday
        profile.email = email
        profile.genderEnum = .init(rawValue: gender?.rawValue ?? .invalid)
        profile.name = name
        profile.phoneNumber = phoneNumber
        profile.station = station

        if isNew {
            profile.identifier = UUID().uuidString
        }
    }

    func iconImageInsert(_ profile: Profile) {
        profile.iconImage = iconImage
    }
}
