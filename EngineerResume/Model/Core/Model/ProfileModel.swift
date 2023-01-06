import Combine
import CoreData

/// @mockable
protocol ProfileModelInput {
    func fetch(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void)
}

final class ProfileModel: ProfileModelInput {
    private var cancellables: Set<AnyCancellable> = .init()

    private let profileConverter: ProfileConverterInput
    private let errorConverter: AppErrorConverterInput

    init(
        profileConverter: ProfileConverterInput,
        errorConverter: AppErrorConverterInput
    ) {
        self.profileConverter = profileConverter
        self.errorConverter = errorConverter
    }

    func fetch(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void) {
        CoreDataManager.shared.request(Profile.self) { [weak self] publisher in
            guard let self else {
                return
            }

            publisher.sink(
                receiveCompletion: { receiveCompletion in
                    if case let .failure(coreDataError) = receiveCompletion {
                        let appError = self.errorConverter.convert(.coreData(coreDataError))
                        completion(.failure(appError))
                    }
                },
                receiveValue: { values in
                    let mapper = self.profileConverter.convert(values)
                    completion(.success(mapper))
                }
            )
            .store(in: &self.cancellables)
        }
    }
}
