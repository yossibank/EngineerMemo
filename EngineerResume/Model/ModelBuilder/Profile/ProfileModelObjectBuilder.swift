#if DEBUG
    final class ProfileModelObjectBuilder {
        private var identifier = "identifier"
        private var name = "testName"
        private var age = 20

        func build() -> ProfileModelObject {
            .init(
                identifier: identifier,
                name: name,
                age: age
            )
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }

        func name(_ name: String) -> Self {
            self.name = name
            return self
        }

        func age(_ age: Int) -> Self {
            self.age = age
            return self
        }
    }
#endif
