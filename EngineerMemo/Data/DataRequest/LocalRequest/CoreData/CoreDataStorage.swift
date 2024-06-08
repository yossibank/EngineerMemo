import Combine
import CoreData

struct CoreDataStorage<T: IdentifableManagedObject> {
    private let shared = CoreDataManager.shared

    var allObjects: [T] {
        let request = NSFetchRequest<T>(entityName: T.className)

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

    func create() -> AnyPublisher<CoreDataObject<T>, Never> {
        Deferred {
            Future<CoreDataObject<T>, Never> { promise in
                shared.performBackgroundTask { context in
                    let object = T(
                        entity: NSEntityDescription.entity(
                            forEntityName: T.className,
                            in: context
                        )!,
                        insertInto: context
                    )

                    promise(
                        .success(
                            .init(
                                object: object,
                                context: context
                            )
                        )
                    )
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func update(identifier: String) -> AnyPublisher<CoreDataObject<T>, Never> {
        Deferred {
            Future<CoreDataObject<T>, Never> { promise in
                shared.performBackgroundTask { context in
                    if let object = object(identifier: identifier) {
                        promise(.success(
                            .init(
                                object: object,
                                context: context
                            )
                        ))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func delete(identifier: String) -> AnyPublisher<Void, Never> {
        Deferred {
            Future<Void, Never> { promise in
                shared.performBackgroundTask { context in
                    if let object = object(identifier: identifier) {
                        context.delete(object)
                        context.saveIfNeeded()
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - private methods

private extension CoreDataStorage {
    func object(identifier: String) -> T? {
        allObjects.filter { $0.identifier == identifier }.first
    }
}
