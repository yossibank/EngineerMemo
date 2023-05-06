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

    private init() {
        let container = NSPersistentCloudKitContainer(name: containerName)

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
