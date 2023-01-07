import CoreData

struct CoreDataStorage<T: IdentifableManagedObject> {
    private let shared = CoreDataManager.shared

    func object(identifier: String) -> T? {
        allObjects().filter { $0.identifier == identifier }.first
    }

    func allObjects() -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))

        guard let result = try? shared.backgroundContext.fetch(request) else {
            return []
        }

        return result
    }

    func create(block: @escaping (T) -> Void) {
        shared.performBackgroundTask {
            let object = T(context: shared.backgroundContext)
            block(object)
            shared.backgroundContext.saveIfNeeded()
        }
    }

    func update(
        identifier: String,
        block: @escaping (T) -> Void
    ) {
        shared.performBackgroundTask {
            if let object = object(identifier: identifier) {
                block(object)
                shared.backgroundContext.saveIfNeeded()
            }
        }
    }

    func publisher(sortDescriptors: [NSSortDescriptor]? = nil) -> CoreDataPublisher<T> {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.sortDescriptors = sortDescriptors

        return .init(
            request: request,
            context: shared.backgroundContext
        )
    }
}
