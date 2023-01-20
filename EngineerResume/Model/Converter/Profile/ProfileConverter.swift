/// @mockable
protocol ProfileConverterInput {
    func convert(_ object: Profile) -> ProfileModelObject
}

struct ProfileConverter: ProfileConverterInput {
    func convert(_ object: Profile) -> ProfileModelObject {
        // NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        ProfileModelObject(
            address: object.address ?? .noSetting,
            age: object.age?.intValue ?? -1,
            email: object.email ?? .noSetting,
            gender: .init(rawValue: object.genderEnum?.rawValue ?? -1),
            name: object.name ?? .noSetting,
            phoneNumber: object.phoneNumber ?? .noSetting,
            station: object.station ?? .noSetting,
            identifier: object.identifier
        )
    }
}
