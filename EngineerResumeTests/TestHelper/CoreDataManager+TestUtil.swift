import CoreData
@testable import EngineerResume

extension CoreDataManager {
    func injectInMemoryPersistentContainer() {
        inject(persistentContainer: {
            let container = NSPersistentCloudKitContainer(name: "EngineerResume")
            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.url = .init(fileURLWithPath: "/dev/null")

            container.persistentStoreDescriptions = [persistentStoreDescription]
            container.viewContext.setupMergeConfig()
            container.loadPersistentStores { _, error in
                if let error {
                    fatalError(error.localizedDescription)
                }
            }

            return container
        }())
    }

    func save<T: NSManagedObject>(
        _ type: T.Type,
        action: @escaping (T) -> Void
    ) {
        performBackgroundTask {
            let context = self.backgroundContext!
            let object = T(context: context)
            action(object)
            context.saveIfNeeded()
        }
    }
}
