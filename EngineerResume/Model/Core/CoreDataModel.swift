import Combine
import CoreData

final class CoreDataModel {
    static let shared = CoreDataModel()

    private var cancellables: Set<AnyCancellable> = .init()

    private init() {}

    func fetch<T: NSManagedObject>(
        _ managedObject: T.Type,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        CoreDataManager.shared.performBackgroundTask { [weak self] context in
            guard let self else {
                return
            }

            CoreDataPublisher(
                request: NSFetchRequest<T>(entityName: String(describing: T.self)),
                context: context
            )
            .sink(
                receiveCompletion: { receiveCompletion in
                    if case let .failure(error) = receiveCompletion {
                        completion(.failure(error))
                    }
                },
                receiveValue: { values in
                    completion(.success(values))
                }
            )
            .store(in: &self.cancellables)
        }
    }
}
