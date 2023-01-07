import CoreData

extension NSManagedObjectContext {
    func saveIfNeeded() {
        guard hasChanges else {
            return
        }

        do {
            try save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func setupMergeConfig() {
        automaticallyMergesChangesFromParent = true
        mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
