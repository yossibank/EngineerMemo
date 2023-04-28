import CoreData

@objc(Skill)
final class Skill: NSManagedObject {
    @NSManaged var career: NSNumber?
    @NSManaged var identifier: String
}

extension Skill: Identifiable, IdentifableManagedObject {}
