/// @mockable
protocol ProfileConverterInput {
    func convert(_ profile: Profile) -> ProfileModelObject
}

struct ProfileConverter: ProfileConverterInput {
    func convert(_ profile: Profile) -> ProfileModelObject {
        // NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        ProfileModelObject(
            address: profile.address ?? .noSetting,
            birthday: profile.birthday,
            email: profile.email ?? .noSetting,
            gender: .init(rawValue: profile.gender?.rawValue ?? .invalid) ?? .noSetting,
            iconImage: profile.iconImage,
            name: profile.name ?? .noSetting,
            phoneNumber: profile.phoneNumber ?? .noSetting,
            station: profile.station ?? .noSetting,
            skill: SkillConverter().convert(profile.skill),
            projects: ProjectConverter().convert(profile.projects?.allObjects as? [Project]),
            identifier: profile.identifier
        )
    }
}
