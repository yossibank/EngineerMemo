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
    var skill: SkillModelObject?
    var projects: [ProjectModelObject] = []
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
        let profileObject = profile.object

        profileObject.address = address
        profileObject.birthday = birthday
        profileObject.email = email
        profileObject.gender = .init(rawValue: gender?.rawValue ?? .invalid)
        profileObject.name = name
        profileObject.phoneNumber = phoneNumber
        profileObject.station = station

        if isNew {
            profileObject.identifier = UUID().uuidString
        }

        context.saveIfNeeded()
    }

    func insertIconImage(_ profile: CoreDataObject<Profile>) {
        let context = profile.context
        let profileObject = profile.object
        profileObject.iconImage = iconImage
        context.saveIfNeeded()
    }
}

// MARK: - スキル情報作成・更新

extension ProfileModelObject {
    func insertSkill(_ profile: CoreDataObject<Profile>) {
        let context = profile.context
        let profileObject = profile.object
        let skillObject = profileObject.skill ?? Skill(context: context)

        skillObject.engineerCareer = .init(value: skill?.engineerCareer ?? .invalid)
        skillObject.language = skill?.language

        if let languageCareer = skill?.languageCareer {
            skillObject.languageCareer = .init(value: languageCareer)
        }

        if let toeic = skill?.toeic {
            skillObject.toeic = .init(value: toeic)
        }

        if profileObject.skill.isNil {
            skillObject.identifier = UUID().uuidString
        }

        profileObject.skill = skillObject

        context.saveIfNeeded()
    }
}

// MARK: - 案件情報作成・更新

extension ProfileModelObject {
    func insertProject(_ profile: CoreDataObject<Profile>) {
        let context = profile.context
        let profileObject = profile.object

        let projects = projects.map { object -> Project in
            let project = Project(context: context)
            project.identifier = UUID().uuidString
            project.title = object.title
            project.content = object.content
            return project
        }

        profileObject.addToProjects(.init(array: projects))

        context.saveIfNeeded()
    }

    func updateProject(
        _ profile: CoreDataObject<Profile>,
        identifier: String
    ) {
        let context = profile.context
        let profileObject = profile.object

        guard
            let projectObjects = profileObject.projects?.allObjects as? [Project],
            let projectObject = projectObjects.filter({ $0.identifier == identifier }).first,
            let project = projects.filter({ $0.identifier == identifier }).first
        else {
            return
        }

        projectObject.title = project.title
        projectObject.content = project.content

        context.saveIfNeeded()
    }
}
