/// @mockable
protocol SkillConverterInput {
    func convert(_ object: Skill?) -> SkillModelObject?
}

struct SkillConverter: SkillConverterInput {
    func convert(_ object: Skill?) -> SkillModelObject? {
        // NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        SkillModelObject(career: object?.career?.intValue)
    }
}
