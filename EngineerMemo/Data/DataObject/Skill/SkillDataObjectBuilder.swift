#if DEBUG
    import CoreData
    import Foundation

    final class SkillDataObjectBuilder {
        private var engineerCareer: NSNumber? = 3
        private var identifier = "identifier"
        private var language: String? = "Swift"
        private var languageCareer: NSNumber? = 2
        private var toeic: NSNumber? = 600
        private var pr: String? = "PR事項"
        private var profile: Profile?

        func build() -> Skill {
            let context = CoreDataManager.shared.backgroundContext!
            let skill = Skill(
                entity: NSEntityDescription.entity(
                    forEntityName: Skill.className,
                    in: context
                )!,
                insertInto: context
            )
            skill.engineerCareer = engineerCareer
            skill.identifier = identifier
            skill.language = language
            skill.languageCareer = languageCareer
            skill.toeic = toeic
            skill.pr = pr
            skill.profile = profile
            return skill
        }

        func engineerCareer(_ engineerCareer: NSNumber?) -> Self {
            self.engineerCareer = engineerCareer
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }

        func language(_ language: String?) -> Self {
            self.language = language
            return self
        }

        func languageCareer(_ languageCareer: NSNumber?) -> Self {
            self.languageCareer = languageCareer
            return self
        }

        func toeic(_ toeic: NSNumber?) -> Self {
            self.toeic = toeic
            return self
        }

        func pr(_ pr: String?) -> Self {
            self.pr = pr
            return self
        }

        func profile(_ profile: Profile?) -> Self {
            self.profile = profile
            return self
        }
    }
#endif
