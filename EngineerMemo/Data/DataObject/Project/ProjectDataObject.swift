import CoreData

@objc(Project)
final class Project: NSManagedObject {
    @NSManaged var content: String?
    @NSManaged var endDate: Date?
    @NSManaged var identifier: String
    @NSManaged var startDate: Date?
    @NSManaged var title: String?
    @NSManaged var profile: Profile?
}

extension Project: Identifiable, IdentifableManagedObject {}
