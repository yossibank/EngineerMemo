import Combine
import CoreData

/// @mockable
protocol ProfileModelInput: Model {
    func fetch(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void)
    func find(identifier: String, completion: @escaping (Result<ProfileModelObject, AppError>) -> Void)
    func create(modelObject: ProfileModelObject)
    func update(modelObject: ProfileModelObject)
    func iconImageUpdate(modelObject: ProfileModelObject)
    func iconImageUpdate(index: Int)
    func skillUpdate(modelObject: ProfileModelObject)
    func delete(modelObject: ProfileModelObject)
}

final class ProfileModel: ProfileModelInput {
    private var cancellables: Set<AnyCancellable> = .init()

    private let profileStorage = CoreDataStorage<Profile>()
    private let skillStorage = CoreDataStorage<Skill>()
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
        profileStorage.publisher().sink(
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
                let modelObjects = values.compactMap {
                    self?.profileConverter.convert($0)
                }
                completion(.success(modelObjects))
            }
        )
        .store(in: &cancellables)
    }

    func find(
        identifier: String,
        completion: @escaping (Result<ProfileModelObject, AppError>) -> Void
    ) {
        profileStorage.publisher().sink(
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
                    let value = values.filter({ $0.identifier == identifier }).first
                else {
                    return
                }

                let modelObject = self.profileConverter.convert(value)
                completion(.success(modelObject))
            }
        )
        .store(in: &cancellables)
    }

    func create(modelObject: ProfileModelObject) {
        profileStorage.create().sink { profile in
            modelObject.basicInsert(
                profile,
                isNew: true
            )
        }
        .store(in: &cancellables)
    }

    func update(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink { profile in
            modelObject.basicInsert(
                profile,
                isNew: false
            )
        }
        .store(in: &cancellables)
    }

    func iconImageUpdate(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink { profile in
            modelObject.iconImageInsert(profile)
        }
        .store(in: &cancellables)
    }

    func iconImageUpdate(index: Int) {
        DataHolder.profileIcon = .init(rawValue: index) ?? .penguin
    }

    func skillUpdate(modelObject: ProfileModelObject) {
        Publishers.CombineLatest(
            skillStorage.create(),
            profileStorage.update(identifier: modelObject.identifier)
        )
        .sink { skill, profile in
            modelObject.skill?.skillInsert(skill)
            profile.skill = skill
        }
        .store(in: &cancellables)
    }

    func delete(modelObject: ProfileModelObject) {
        profileStorage.delete(identifier: modelObject.identifier)
    }
}
