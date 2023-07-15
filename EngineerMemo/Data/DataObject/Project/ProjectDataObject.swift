import CoreData

@objc(Project)
final class Project: NSManagedObject {
    @NSManaged var content: String?
    @NSManaged var database: String?
    @NSManaged var endDate: Date?
    @NSManaged var identifier: String
    @NSManaged var language: String?
    @NSManaged var processes: [Int]
    @NSManaged var role: String?
    @NSManaged var serverOS: String?
    @NSManaged var startDate: Date?
    @NSManaged var title: String?
    @NSManaged var tools: [String]
    @NSManaged var profile: Profile?
}

extension Project: Identifiable, IdentifableManagedObject {}
