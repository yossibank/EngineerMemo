import Foundation

struct SkillModelObject: Hashable {
    var career: Int?
    var identifier: String
}

extension SkillModelObject {
    func skillInsert(_ skill: Skill) {
        if let career {
            skill.career = .init(value: career)
            skill.identifier = UUID().uuidString
        }
    }
}
