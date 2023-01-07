import Combine
import CoreData

/// @mockable
protocol ProfileModelInput: Model {
    func get(completion: @escaping (Result<ProfileModelObject, AppError>) -> Void)
    func update(modelObject: ProfileModelObject)
}

final class ProfileModel: ProfileModelInput {
    private var cancellables: Set<AnyCancellable> = .init()

    private let storage = CoreDataStorage<Profile>()
    private let profileConverter: ProfileConverterInput
    private let errorConverter: AppErrorConverterInput

    init(
        profileConverter: ProfileConverterInput,
        errorConverter: AppErrorConverterInput
    ) {
        self.profileConverter = profileConverter
        self.errorConverter = errorConverter
    }

    func get(completion: @escaping (Result<ProfileModelObject, AppError>) -> Void) {
        storage.publisher()
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
                    guard
                        let self,
                        let value = values.first
                    else {
                        return
                    }

                    let modelObject = self.profileConverter.convert(value)
                    completion(.success(modelObject))
                }
            )
            .store(in: &cancellables)
    }

    func update(modelObject: ProfileModelObject) {
        storage.update { profile in
            profile.name = modelObject.name
            profile.age = .init(value: modelObject.age)
        }
    }
}
