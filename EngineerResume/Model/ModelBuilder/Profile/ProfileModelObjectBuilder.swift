#if DEBUG
    final class ProfileModelObjectBuilder {
        private var address: String? = "テスト県テスト市テスト1-1-1"
        private var age: Int? = 20
        private var email: String? = "test@test.com"
        private var gender: ProfileModelObject.Gender? = .man
        private var name: String? = "testName"
        private var phoneNumber: Int? = 11_123_456_789
        private var station: String? = "鶴橋駅"
        private var identifier = "identifier"

        func build() -> ProfileModelObject {
            .init(
                address: address,
                age: age,
                email: email,
                gender: gender,
                name: name,
                phoneNumber: phoneNumber,
                station: station,
                identifier: identifier
            )
        }

        func address(_ address: String?) -> Self {
            self.address = address
            return self
        }

        func age(_ age: Int?) -> Self {
            self.age = age
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

        func phoneNumber(_ phoneNumber: Int?) -> Self {
            self.phoneNumber = phoneNumber
            return self
        }

        func station(_ station: String?) -> Self {
            self.station = station
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }
    }
#endif
