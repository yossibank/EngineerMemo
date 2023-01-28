import Foundation

struct ProfileModelObject: Hashable {
    var address: String?
    var birthday: Date?
    var email: String?
    var gender: Gender?
    var name: String?
    var phoneNumber: String?
    var station: String?
    var identifier: String

    enum Gender: Int {
        case man = 0
        case woman
        case other
        case none

        var value: String {
            switch self {
            case .man: return L10n.Profile.Gender.man
            case .woman: return L10n.Profile.Gender.woman
            case .other: return L10n.Profile.Gender.other
            case .none: return .noSetting
            }
        }
    }
}

extension ProfileModelObject {
    func dataInsert(
        _ profile: Profile,
        isNew: Bool
    ) {
        profile.address = address

        if let birthday {
            profile.birthday = birthday
        }

        profile.email = email

        if let gender {
            profile.genderEnum = .init(rawValue: gender.rawValue)
        }

        profile.name = name
        profile.phoneNumber = phoneNumber
        profile.station = station

        if isNew {
            profile.identifier = UUID().uuidString
        }
    }
}
