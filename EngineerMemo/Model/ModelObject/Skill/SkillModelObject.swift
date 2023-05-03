import Foundation

struct SkillModelObject: Hashable {
    var engineerCareer: Int?
    var language: String?
    var languageCareer: Int?
    var toeic: Int?
    var identifier: String
}

extension SkillModelObject {
    func skillInsert(_ skill: Skill) {
        if let engineerCareer {
            skill.engineerCareer = .init(value: engineerCareer)
        }

        if let language {
            skill.language = language

            if let languageCareer {
                skill.languageCareer = .init(value: languageCareer)
            }
        }

        if let toeic {
            skill.toeic = .init(value: toeic)
        }

        skill.identifier = UUID().uuidString
    }
}
