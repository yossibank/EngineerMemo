import Foundation

struct ProfileModelObject: Hashable {
    let address: String
    let age: Int
    let email: String
    let gender: Gender
    let identifier: String
    let name: String
    let phoneNumber: Int
    let station: String

    enum Gender: Int {
        case man
        case woman
        case other
    }
}

extension ProfileModelObject {
    func dataInsert(
        _ profile: Profile,
        isNew: Bool
    ) {
        profile.address = address
        profile.age = .init(value: age)
        profile.email = email
        profile.genderEnum = .init(rawValue: gender.rawValue)
        profile.name = name
        profile.phoneNumber = .init(value: phoneNumber)
        profile.station = station

        if isNew {
            profile.identifier = UUID().uuidString
        }
    }
}
