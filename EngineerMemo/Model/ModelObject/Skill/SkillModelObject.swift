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
        _ skill: Skill,
        isNew: Bool
    ) {
        skill.engineerCareer = .init(value: engineerCareer ?? .invalid)
        skill.language = language
        skill.languageCareer = .init(value: languageCareer ?? .invalid)
        skill.toeic = .init(value: toeic ?? .invalid)

        if isNew {
            skill.identifier = UUID().uuidString
        }
    }
}
