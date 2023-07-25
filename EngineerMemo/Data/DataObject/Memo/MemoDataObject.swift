import CoreData

@objc(Memo)
final class Memo: NSManagedObject {
    @NSManaged var categoryNumber: NSNumber?
    @NSManaged var content: String?
    @NSManaged var createdAt: Date?
    @NSManaged var identifier: String
    @NSManaged var title: String?
}

extension Memo {
    enum Category: Int {
        case todo
        case technical
        case interview
        case event
        case tax
        case other
        case widget
    }

    var category: Category? {
        get {
            .init(rawValue: categoryNumber?.intValue ?? .invalid)
        }
        set {
            categoryNumber = .init(value: newValue?.rawValue ?? .invalid)
        }
    }
}

extension Memo: Identifiable, IdentifableManagedObject {}
