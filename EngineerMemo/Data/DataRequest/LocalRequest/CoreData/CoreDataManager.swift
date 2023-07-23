import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private(set) var backgroundContext: NSManagedObjectContext! {
        didSet {
            backgroundContext.setupMergeConfig()
        }
    }

    private var persistentContainer: NSPersistentContainer

    private let containerName = "EngineerMemo"
    private let sqliteName = "EngineerMemo.sqlite"

    private init() {
        let container = NSPersistentCloudKitContainer(name: containerName)

        if DataHolder.isCoreDataMigrated {
            let newStoreURL = AppGroups.containerURL.appendingPathComponent(sqliteName)
            let description = NSPersistentStoreDescription(url: newStoreURL)
            container.persistentStoreDescriptions = [description]
        }

        container.viewContext.setupMergeConfig()
        container.loadPersistentStores { _, error in
            if let error {
                Logger.error(message: error.localizedDescription)
            }
        }

        self.backgroundContext = container.newBackgroundContext()
        backgroundContext.setupMergeConfig()

        try? backgroundContext.setQueryGenerationFrom(.current)

        self.persistentContainer = container
    }
}

extension CoreDataManager {
    func inject(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        backgroundContext = persistentContainer.newBackgroundContext()
    }

    func migrate() {
        guard !DataHolder.isCoreDataMigrated else {
            Logger.info(message: "CoreDataのマイグレーション完了済み")
            return
        }

        let oldStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(sqliteName)
        let newStoreURL = AppGroups.containerURL.appendingPathComponent(sqliteName)
        let coordinator = persistentContainer.persistentStoreCoordinator

        guard let oldStore = coordinator.persistentStore(for: oldStoreURL) else {
            Logger.warning(message: "CoreDataの保存先URLが見つかりませんでした")
            return
        }

        do {
            try coordinator.migratePersistentStore(
                oldStore,
                to: newStoreURL,
                withType: NSSQLiteStoreType
            )

            DataHolder.isCoreDataMigrated = true

            Logger.info(message: "CoreDataのマイグレーション完了")
        } catch {
            Logger.error(message: "CoreDataのマイグレーション失敗。\(oldStoreURL) => \(newStoreURL)")
        }
    }

    func performBackgroundTask(_ block: @escaping VoidBlock) {
        backgroundContext.perform {
            block()
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        backgroundContext.perform {
            block(self.backgroundContext)
        }
    }

    func deleteAllObjects() {
        let context = persistentContainer.viewContext

        persistentContainer.managedObjectModel.entities
            .compactMap(\.name)
            .forEach {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: $0)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    let deleteResult = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult

                    if let objectIDs = deleteResult?.result as? [NSManagedObjectID] {
                        NSManagedObjectContext.mergeChanges(
                            fromRemoteContextSave: [NSDeletedObjectIDsKey: objectIDs],
                            into: [context]
                        )
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
            }

        context.reset()
    }
}
