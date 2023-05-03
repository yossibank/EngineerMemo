import Foundation

struct SkillModelObject: Hashable {
    var career: Int?
    var toeic: Int?
    var identifier: String
}

extension SkillModelObject {
    func skillInsert(_ skill: Skill) {
        if let career {
            skill.career = .init(value: career)
        }

        if let toeic {
            skill.toeic = .init(value: toeic)
        }

        skill.identifier = UUID().uuidString
    }
}
