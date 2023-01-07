#if DEBUG
    import Foundation

    final class ProfileDataObjectBuilder {
        private var name = "testName"
        private var age: NSNumber? = 20

        func build() -> Profile {
            let context = CoreDataManager.shared.backgroundContext!
            let profile = Profile(context: context)
            profile.name = name
            profile.age = age
            return profile
        }

        func name(_ name: String) -> Self {
            self.name = name
            return self
        }

        func age(_ age: NSNumber?) -> Self {
            self.age = age
            return self
        }
    }
#endif
