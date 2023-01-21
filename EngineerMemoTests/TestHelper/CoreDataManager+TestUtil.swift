import CoreData
@testable import EngineerMemo

extension CoreDataManager {
    func injectInMemoryPersistentContainer() {
        inject(persistentContainer: {
            let container = NSPersistentCloudKitContainer(name: "EngineerMemo")
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
}
