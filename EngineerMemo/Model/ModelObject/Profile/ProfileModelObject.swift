import Foundation

struct ProfileModelObject: Hashable {
    var address: String?
    var birthday: Date?
    var email: String?
    var gender: Gender?
    var iconImage: Data?
    var name: String?
    var phoneNumber: String?
    var station: String?
    var skillModelObject: SkillModelObject?
    var projectModelObjects: [ProjectModelObject] = []
    var identifier: String

    enum Gender: Int {
        case man
        case woman
        case other
        case noSetting

        var value: String {
            switch self {
            case .man: return L10n.Profile.Gender.man
            case .woman: return L10n.Profile.Gender.woman
            case .other: return L10n.Profile.Gender.other
            case .noSetting: return .noSetting
            }
        }
    }
}

// MARK: - 基本情報作成・更新

extension ProfileModelObject {
    func insertBasic(
        _ profile: CoreDataObject<Profile>,
        isNew: Bool
    ) {
        let context = profile.context
        let profile = profile.object

        profile.address = address
        profile.birthday = birthday
        profile.email = email
        profile.gender = .init(rawValue: gender?.rawValue ?? .invalid)
        profile.name = name
        profile.phoneNumber = phoneNumber
        profile.station = station

        if isNew {
            profile.identifier = UUID().uuidString
        }

        context.saveIfNeeded()
    }

    func insertIconImage(_ profile: CoreDataObject<Profile>) {
        let context = profile.context
        let profile = profile.object
        profile.iconImage = iconImage
        context.saveIfNeeded()
    }
}

// MARK: - スキル情報作成・更新

extension ProfileModelObject {
    func insertSkill(
        profile: CoreDataObject<Profile>,
        skill: CoreDataObject<Skill>,
        isNew: Bool
    ) {
        let context = profile.context
        let profile = profile.object
        let skill = skill.object

        skill.engineerCareer = .init(value: skillModelObject?.engineerCareer ?? .invalid)
        skill.language = skillModelObject?.language

        if let languageCareer = skillModelObject?.languageCareer {
            skill.languageCareer = .init(value: languageCareer)
        }

        if let toeic = skillModelObject?.toeic {
            skill.toeic = .init(value: toeic)
        }

        if isNew {
            skill.identifier = UUID().uuidString
        }

        profile.skill = skill

        context.saveIfNeeded()
    }
}

// MARK: - 案件情報作成・更新

extension ProfileModelObject {
    func insertProject(profile: CoreDataObject<Profile>) {
        let context = profile.context
        let profile = profile.object

        let projects = projectModelObjects.map { object -> Project in
            let project = Project(context: context)
            project.title = object.title
            project.content = object.content
            project.identifier = UUID().uuidString
            return project
        }

        profile.addToProjects(.init(array: projects))

        context.saveIfNeeded()
    }
}
