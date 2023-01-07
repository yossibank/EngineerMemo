import CoreData

@objc(Profile)
final class Profile: NSManagedObject {
    @NSManaged var age: NSNumber?
    @NSManaged var identifier: String
    @NSManaged var name: String?
}

extension Profile: Identifiable, IdentifableManagedObject {}
