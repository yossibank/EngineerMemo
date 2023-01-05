import CoreData
@testable import EngineerResume

extension CoreDataManager {
    func injectInMemoryPersistentContainer() {
        inject(persistentContainer: {
            let container = NSPersistentCloudKitContainer(name: "EngineerResume")
            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.url = .init(fileURLWithPath: "/dev/null")

            container.viewContext.setupMergeConfig()
            container.loadPersistentStores { _, error in
                if let error {
                    fatalError(error.localizedDescription)
                }
            }

            return container
        }())
    }
}
