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

    func publisher(sortDescriptors: [NSSortDescriptor]? = nil) -> CoreDataPublisher<T> {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.sortDescriptors = sortDescriptors

        return .init(
            request: request,
            context: shared.backgroundContext
        )
    }

    func create() -> AnyPublisher<T, Never> {
        Deferred {
            Future<T, Never> { promise in
                shared.performBackgroundTask { context in
                    let object = T(context: context)
                    promise(.success(object))
                    context.saveIfNeeded()
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func update(identifier: String) -> AnyPublisher<T, Never> {
        Deferred {
            Future<T, Never> { promise in
                shared.performBackgroundTask { context in
                    if let object = object(identifier: identifier) {
                        promise(.success(object))
                        context.saveIfNeeded()
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func delete(identifier: String) {
        shared.performBackgroundTask { context in
            if let object = object(identifier: identifier) {
                context.delete(object)
                context.saveIfNeeded()
            }
        }
    }
}

private extension CoreDataStorage {
    func object(identifier: String) -> T? {
        allObjects.filter {
            $0.identifier == identifier
        }.first
    }
}
