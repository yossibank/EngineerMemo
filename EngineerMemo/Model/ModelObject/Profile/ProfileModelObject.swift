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
    var projects: [ProjectModelObject] = []
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
    func insertBasic(
        _ data: CoreDataObject<Profile>,
        isNew: Bool
    ) {
        let profile = data.object
        profile.address = address
        profile.birthday = birthday
        profile.email = email
        profile.gender = .init(rawValue: gender?.rawValue ?? .invalid)
        profile.name = name
        profile.phoneNumber = phoneNumber
        profile.station = station

        if isNew {
            profile.identifier = UUID().uuidString
        }

        data.context.saveIfNeeded()
    }

    func insertIconImage(_ data: CoreDataObject<Profile>) {
        let profile = data.object
        profile.iconImage = iconImage
        data.context.saveIfNeeded()
    }
}
