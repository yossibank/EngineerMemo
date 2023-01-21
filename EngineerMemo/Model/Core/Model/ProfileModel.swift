import Combine
import CoreData

/// @mockable
protocol ProfileModelInput: Model {
    func get(completion: @escaping (Result<ProfileModelObject, AppError>) -> Void)
    func gets(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void)
    func create(modelObject: ProfileModelObject)
    func update(modelObject: ProfileModelObject)
    func delete(modelObject: ProfileModelObject)
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

    func gets(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void) {
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
                    let modelObject = values.compactMap {
                        self?.profileConverter.convert($0)
                    }
                    completion(.success(modelObject))
                }
            )
            .store(in: &cancellables)
    }

    func create(modelObject: ProfileModelObject) {
        storage.create()
            .sink { profile in
                modelObject.dataInsert(
                    profile,
                    isNew: true
                )
            }
            .store(in: &cancellables)
    }

    func update(modelObject: ProfileModelObject) {
        storage.update(identifier: modelObject.identifier)
            .sink { profile in
                modelObject.dataInsert(
                    profile,
                    isNew: false
                )
            }
            .store(in: &cancellables)
    }

    func delete(modelObject: ProfileModelObject) {
        storage.delete(identifier: modelObject.identifier)
    }
}
