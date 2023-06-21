import Foundation

struct SkillModelObject: Hashable {
    var engineerCareer: Int?
    var language: String?
    var languageCareer: Int?
    var toeic: Int?
    var identifier: String
}

extension SkillModelObject {
    func skillInsert(
        _ data: CoreDataObject<Skill>,
        isNew: Bool
    ) {
        let skill = data.object
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

        data.context.saveIfNeeded()
    }
}
