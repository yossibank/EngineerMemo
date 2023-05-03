import CoreData

@objc(Skill)
final class Skill: NSManagedObject {
    @NSManaged var engineerCareer: NSNumber?
    @NSManaged var identifier: String
    @NSManaged var language: String?
    @NSManaged var languageCareer: NSNumber?
    @NSManaged var toeic: NSNumber?
    @NSManaged var profile: Profile?
}

extension Skill: Identifiable, IdentifableManagedObject {}
