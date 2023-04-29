/// @mockable
protocol SkillConverterInput {
    func convert(_ skill: Skill?) -> SkillModelObject?
}

struct SkillConverter: SkillConverterInput {
    func convert(_ skill: Skill?) -> SkillModelObject? {
        // NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        guard let skill else {
            return nil
        }

        return SkillModelObject(
            career: skill.career?.intValue,
            identifier: skill.identifier
        )
    }
}
