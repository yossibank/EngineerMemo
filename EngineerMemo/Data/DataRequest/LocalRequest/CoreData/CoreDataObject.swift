import CoreData

struct CoreDataObject<T: IdentifableManagedObject> {
    let object: T
    let context: NSManagedObjectContext
}
