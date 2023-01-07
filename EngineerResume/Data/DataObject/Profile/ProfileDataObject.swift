import CoreData

@objc(Profile)
final class Profile: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var age: NSNumber?
}

extension Profile: Identifiable {}
