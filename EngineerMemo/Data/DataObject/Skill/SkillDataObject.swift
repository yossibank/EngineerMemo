import CoreData

@objc(Skill)
final class Skill: NSManagedObject {
    @NSManaged var career: NSNumber?
    @NSManaged var identifier: String
    @NSManaged var profile: Profile?
}

extension Skill: Identifiable, IdentifableManagedObject {}
