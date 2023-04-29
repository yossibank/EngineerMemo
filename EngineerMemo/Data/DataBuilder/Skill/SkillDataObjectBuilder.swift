#if DEBUG
    import Foundation

    final class SkillDataObjectBuilder {
        private var career: NSNumber? = 3
        private var identifier = "identifier"
        private var profile: Profile?

        func build() -> Skill {
            let context = CoreDataManager.shared.backgroundContext!
            let skill = Skill(context: context)
            skill.career = career
            skill.identifier = identifier
            skill.profile = profile
            return skill
        }

        func career(_ career: NSNumber?) -> Self {
            self.career = career
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }

        func profile(_ profile: Profile?) -> Self {
            self.profile = profile
            return self
        }
    }
#endif
