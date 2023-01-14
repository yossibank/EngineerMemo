#if DEBUG
    final class ProfileModelObjectBuilder {
        private var address = "テスト県テスト市テスト1-1-1"
        private var age = 20
        private var email = "test@test.com"
        private var gender: ProfileModelObject.Gender = .man
        private var identifier = "identifier"
        private var name = "testName"
        private var phoneNumber = 08_011_112_222
        private var station = "鶴橋駅"

        func build() -> ProfileModelObject {
            .init(
                address: address,
                age: age,
                email: email,
                gender: gender,
                identifier: identifier,
                name: name,
                phoneNumber: phoneNumber,
                station: station
            )
        }

        func address(_ address: String) -> Self {
            self.address = address
            return self
        }

        func age(_ age: Int) -> Self {
            self.age = age
            return self
        }

        func email(_ email: String) -> Self {
            self.email = email
            return self
        }

        func gender(_ gender: ProfileModelObject.Gender) -> Self {
            self.gender = gender
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }

        func name(_ name: String) -> Self {
            self.name = name
            return self
        }

        func phoneNumber(_ phoneNumber: Int) -> Self {
            self.phoneNumber = phoneNumber
            return self
        }

        func station(_ station: String) -> Self {
            self.station = station
            return self
        }
    }
#endif
