import CoreData

@objc(Profile)
final class Profile: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var age: NSNumber?

    @nonobjc class func fetchRequest() -> NSFetchRequest<Profile> {
        NSFetchRequest<Profile>(entityName: "Profile")
    }
}

extension Profile: Identifiable {}
