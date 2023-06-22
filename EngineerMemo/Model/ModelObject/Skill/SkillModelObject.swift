import Foundation

struct SkillModelObject: Hashable {
    var engineerCareer: Int?
    var language: String?
    var languageCareer: Int?
    var toeic: Int?
    var identifier: String
}

extension SkillModelObject {
    func insertSkill(
        profile: CoreDataObject<Profile>,
        skill: CoreDataObject<Skill>,
        isNew: Bool
    ) {
        let context = profile.context
        let profile = profile.object
        let skill = skill.object
        skill.engineerCareer = .init(value: engineerCareer ?? .invalid)
        skill.language = language

        if let languageCareer {
            skill.languageCareer = .init(value: languageCareer)
        }

        if let toeic {
            skill.toeic = .init(value: toeic)
        }

        if isNew {
            skill.identifier = UUID().uuidString
        }

        profile.skill = skill

        context.saveIfNeeded()
    }
}
