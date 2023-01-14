#if DEBUG
    import Foundation

    final class ProfileDataObjectBuilder {
        private var address: String? = "テスト県テスト市テスト1-1-1"
        private var age: NSNumber? = 20
        private var email: String? = "test@test.com"
        private var gender: Profile.Gender? = .man
        private var identifier = "identifier"
        private var name: String? = "testName"
        private var phoneNumber: NSNumber? = 08_011_112_222
        private var station: String? = "鶴橋駅"

        func build() -> Profile {
            let context = CoreDataManager.shared.backgroundContext!
            let profile = Profile(context: context)
            profile.address = address
            profile.age = age
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

        func age(_ age: NSNumber?) -> Self {
            self.age = age
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

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }

        func name(_ name: String?) -> Self {
            self.name = name
            return self
        }

        func phoneNumber(_ phoneNumber: NSNumber?) -> Self {
            self.phoneNumber = phoneNumber
            return self
        }

        func station(_ station: String?) -> Self {
            self.station = station
            return self
        }
    }
#endif
