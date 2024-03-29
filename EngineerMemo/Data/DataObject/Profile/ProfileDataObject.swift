import CoreData

@objc(Profile)
final class Profile: NSManagedObject {
    @NSManaged var address: String?
    @NSManaged var birthday: Date?
    @NSManaged var email: String?
    @NSManaged var genderNumber: NSNumber?
    @NSManaged var iconImage: Data?
    @NSManaged var identifier: String
    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var station: String?
    @NSManaged var skill: Skill?
    @NSManaged var projects: NSSet?
}

extension Profile {
    @objc(addProjectsObject:)
    @NSManaged func addToProjects(_ value: Project)

    @objc(removeProjectsObject:)
    @NSManaged func removeFromProjects(_ value: Project)

    @objc(addProjects:)
    @NSManaged func addToProjects(_ values: NSSet)

    @objc(removeProjects:)
    @NSManaged func removeFromProjects(_ values: NSSet)
}

extension Profile {
    enum Gender: Int {
        case man
        case woman
        case other
    }

    var gender: Gender? {
        get {
            .init(rawValue: genderNumber?.intValue ?? .invalid)
        }
        set {
            genderNumber = .init(value: newValue?.rawValue ?? .invalid)
        }
    }
}

extension Profile: Identifiable, IdentifableManagedObject {}
