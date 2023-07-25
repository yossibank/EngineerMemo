import CoreData
@testable import EngineerMemo

extension CoreDataManager {
    private static let managedObjectModel = NSManagedObjectModel.mergedModel(
        from: [Bundle(for: CoreDataManager.self)]
    )!

    func injectInMemoryPersistentContainer() {
        inject(persistentContainer: {
            let container = NSPersistentCloudKitContainer(
                name: Self.containerName,
                managedObjectModel: CoreDataManager.managedObjectModel
            )

            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.url = .init(fileURLWithPath: "/dev/null")

            container.persistentStoreDescriptions = [persistentStoreDescription]
            container.viewContext.setupMergeConfig()
            container.loadPersistentStores { _, error in
                if let error {
                    Logger.error(message: error.localizedDescription)
                }
            }

            return container
        }())
    }
}
