/// @mockable
protocol ProfileConverterInput {
    func convert(_ object: Profile) -> ProfileModelObject
}

struct ProfileConverter: ProfileConverterInput {
    func convert(_ object: Profile) -> ProfileModelObject {
        // NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        ProfileModelObject(
            address: object.address ?? "",
            age: object.age?.intValue ?? -1,
            email: object.email ?? "",
            gender: .init(rawValue: object.genderEnum?.rawValue ?? -1) ?? .other,
            identifier: object.identifier,
            name: object.name ?? "",
            phoneNumber: object.phoneNumber?.intValue ?? -1,
            station: object.station ?? ""
        )
    }
}
