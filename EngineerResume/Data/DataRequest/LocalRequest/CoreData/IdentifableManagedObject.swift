import CoreData

protocol IdentifableManagedObject: NSManagedObject {
    var identifier: String { get }
}
