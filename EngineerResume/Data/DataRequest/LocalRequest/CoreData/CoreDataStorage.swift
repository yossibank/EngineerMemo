import Combine
import CoreData

struct CoreDataStorage<T: IdentifableManagedObject> {
    private let shared = CoreDataManager.shared

    var allObjects: [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))

        guard let result = try? shared.backgroundContext.fetch(request) else {
            return []
        }

        return result
    }

    func object(identifier: String) -> T? {
        allObjects.filter {
            $0.identifier == identifier
        }.first
    }

    func create() -> AnyPublisher<T, Never> {
        Deferred {
            Future<T, Never> { promise in
                shared.performBackgroundTask {
                    let object = T(context: shared.backgroundContext)
                    promise(.success(object))
                    shared.backgroundContext.saveIfNeeded()
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func update(identifier: String) -> AnyPublisher<T, Never> {
        Deferred {
            Future<T, Never> { promise in
                shared.performBackgroundTask {
                    if let object = object(identifier: identifier) {
                        promise(.success(object))
                        shared.backgroundContext.saveIfNeeded()
                    }
                }
            }
        }
        .eraseToAnyPublisher()
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
