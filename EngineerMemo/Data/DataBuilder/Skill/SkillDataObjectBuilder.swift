#if DEBUG
    import Foundation

    final class SkillDataObjectBuilder {
        private var career: NSNumber? = .init(value: 3)
        private var identifier = "identifier"

        func build() -> Skill {
            let context = CoreDataManager.shared.backgroundContext!
            let skill = Skill(context: context)
            skill.career = career
            skill.identifier = identifier
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
    }
#endif
