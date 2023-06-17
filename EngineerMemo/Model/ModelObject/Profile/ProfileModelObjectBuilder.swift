#if DEBUG
    import Foundation

    final class ProfileModelObjectBuilder {
        private var address: String? = "テスト県テスト市テスト1-1-1"
        private var birthday = Calendar.date(year: 2000, month: 1, day: 1)
        private var email: String? = "test@test.com"
        private var gender: ProfileModelObject.Gender? = .man
        private var iconImage: Data? = Asset.penguin.image.pngData()
        private var name: String? = "testName"
        private var phoneNumber: String? = "08011112222"
        private var station: String? = "鶴橋駅"
        private var skill: SkillModelObject?
        private var projects: [ProjectModelObject] = []
        private var identifier = "identifier"

        func build() -> ProfileModelObject {
            .init(
                address: address,
                birthday: birthday,
                email: email,
                gender: gender,
                iconImage: iconImage,
                name: name,
                phoneNumber: phoneNumber,
                station: station,
                skill: skill,
                projects: projects,
                identifier: identifier
            )
        }

        func address(_ address: String?) -> Self {
            self.address = address
            return self
        }

        func birthday(_ birthday: Date?) -> Self {
            self.birthday = birthday
            return self
        }

        func email(_ email: String?) -> Self {
            self.email = email
            return self
        }

        func gender(_ gender: ProfileModelObject.Gender?) -> Self {
            self.gender = gender
            return self
        }

        func name(_ name: String?) -> Self {
            self.name = name
            return self
        }

        func iconImage(_ iconImage: Data?) -> Self {
            self.iconImage = iconImage
            return self
        }

        func phoneNumber(_ phoneNumber: String?) -> Self {
            self.phoneNumber = phoneNumber
            return self
        }

        func station(_ station: String?) -> Self {
            self.station = station
            return self
        }

        func skill(_ skill: SkillModelObject?) -> Self {
            self.skill = skill
            return self
        }

        func projects(_ projects: [ProjectModelObject]) -> Self {
            self.projects = projects
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }
    }
#endif
