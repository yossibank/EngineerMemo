import Combine
import CoreData

/// @mockable
protocol ProfileModelInput: Model {
    func get(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void)
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

    func get(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void) {
        CoreDataManager.shared.fetch(Profile.self)
            .sink(
                receiveCompletion: { [weak self] receiveCompletion in
                    guard let self else {
                        return
                    }

                    if case let .failure(coreDataError) = receiveCompletion {
                        let appError = self.errorConverter.convert(.coreData(coreDataError))
                        completion(.failure(appError))
                    }
                },
                receiveValue: { [weak self] values in
                    guard let self else {
                        return
                    }

                    let modelObject = self.profileConverter.convert(values)
                    completion(.success(modelObject))
                }
            )
            .store(in: &cancellables)
    }
}
