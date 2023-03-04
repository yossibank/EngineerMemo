import CoreData

@objc(Memo)
final class Memo: NSManagedObject {
    @NSManaged var content: String?
    @NSManaged var identifier: String
    @NSManaged var title: String?
}

extension Memo: Identifiable, IdentifableManagedObject {}
