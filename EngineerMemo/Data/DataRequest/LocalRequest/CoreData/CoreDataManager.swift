import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    static let containerName = "EngineerMemo"
    static let sqliteName = "EngineerMemo.sqlite"

    private(set) var backgroundContext: NSManagedObjectContext! {
        didSet {
            backgroundContext.setupMergeConfig()
        }
    }

    private(set) var oldStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(sqliteName)
    private(set) var newStoreURL = AppGroups.containerURL.appendingPathComponent(sqliteName)

    private var persistentContainer: NSPersistentContainer

    private init() {
        let container = NSPersistentCloudKitContainer(name: Self.containerName)

        if DataHolder.isCoreDataMigrated {
            let newStoreURL = AppGroups.containerURL.appendingPathComponent(Self.sqliteName)
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

        self.persistentContainer = container
    }
}

extension CoreDataManager {
    func inject(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        backgroundContext = persistentContainer.newBackgroundContext()
    }

    func migrate(
        oldStoreURL: URL,
        newStoreURL: URL
    ) {
        guard !DataHolder.isCoreDataMigrated else {
            Logger.info(message: "CoreDataのマイグレーション完了済み")
            return
        }

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

    // NOTE: Batch deletes are only available when you are using a SQLite persistent store.
    func deleteAllObjects() {
        let context = persistentContainer.viewContext

        persistentContainer.managedObjectModel.entities
            .compactMap(\.name)
            .forEach {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: $0)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try context.execute(batchDeleteRequest)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }

        context.reset()
    }
}
