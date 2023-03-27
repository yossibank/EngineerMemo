#if DEBUG
    import Foundation

    final class ProfileDataObjectBuilder {
        private var address: String? = "テスト県テスト市テスト1-1-1"
        private var birthday = Calendar.date(year: 2000, month: 1, day: 1)
        private var email: String? = "test@test.com"
        private var gender: Profile.Gender? = .man
        private var iconImage: Data? = ImageResources.profile?.pngData()
        private var identifier = "identifier"
        private var name: String? = "testName"
        private var phoneNumber: String? = "08011112222"
        private var station: String? = "鶴橋駅"

        func build() -> Profile {
            let context = CoreDataManager.shared.backgroundContext!
            let profile = Profile(context: context)
            profile.address = address
            profile.birthday = birthday
            profile.email = email
            profile.genderEnum = gender
            profile.identifier = identifier
            profile.name = name
            profile.phoneNumber = phoneNumber
            profile.station = station
            return profile
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

        func gender(_ gender: Profile.Gender?) -> Self {
            self.gender = gender
            return self
        }

        func iconImage(_ iconImage: Data?) -> Self {
            self.iconImage = iconImage
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }

        func name(_ name: String?) -> Self {
            self.name = name
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
    }
#endif
