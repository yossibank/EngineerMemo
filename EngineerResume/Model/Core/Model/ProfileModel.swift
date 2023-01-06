import Combine
import CoreData

/// @mockable
protocol ProfileModelInput {
    func fetch(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void)
}

final class ProfileModel: ProfileModelInput {
    private var cancellables: Set<AnyCancellable> = .init()

    func fetch(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void) {
        CoreDataRequest().request(Profile.self) { [weak self] publisher in
            guard let self else {
                return
            }

            publisher.sink(
                receiveCompletion: { receiveCompletion in
                    if case let .failure(error) = receiveCompletion {
                        let appError = AppErrorConverter()
                            .convert(.coreData(.something(error.localizedDescription)))
                        completion(.failure(appError))
                    }
                },
                receiveValue: { values in
                    let mapper = ProfileConverter().convert(values)
                    completion(.success(mapper))
                }
            )
            .store(in: &self.cancellables)
        }
    }
}
