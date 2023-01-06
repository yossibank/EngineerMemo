import Combine
import CoreData

struct CoreDataRequest {
    func request<T: NSManagedObject>(
        _ object: T.Type,
        publisher: @escaping (CoreDataPublisher<T>) -> Void
    ) {
        CoreDataManager.shared.performBackgroundTask { context in
            publisher(
                CoreDataPublisher(
                    request: NSFetchRequest<T>(entityName: String(describing: T.self)),
                    context: context
                )
            )
        }
    }
}
