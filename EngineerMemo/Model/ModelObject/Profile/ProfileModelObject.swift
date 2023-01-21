import Foundation

struct ProfileModelObject: Hashable {
    var address: String?
    var age: Int?
    var email: String?
    var gender: Gender?
    var name: String?
    var phoneNumber: String?
    var station: String?
    let identifier: String

    enum Gender: Int {
        case man = 0
        case woman
        case other
        case none

        var value: String {
            switch self {
            case .man: return "男性"
            case .woman: return "女性"
            case .other: return "その他"
            case .none: return "未設定"
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

        if let age {
            profile.age = .init(value: age)
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
