#if DEBUG
    final class ProfileModelObjectBuilder {
        private var name = "testName"
        private var age = 20

        func build() -> ProfileModelObject {
            .init(
                name: name,
                age: age
            )
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
