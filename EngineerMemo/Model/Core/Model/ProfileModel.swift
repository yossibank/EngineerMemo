import Combine

/// @mockable
protocol ProfileModelInput: Model {
    func fetch() -> AnyPublisher<[ProfileModelObject], AppError>
    func find(identifier: String) -> AnyPublisher<ProfileModelObject, AppError>
    func createBasic(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func updateBasic(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func insertSkill(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func deleteSkill(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func createProject(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func updateProject(_ modelObject: ProfileModelObject, identifier: String) -> AnyPublisher<Void, Never>
    func deleteProject(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func updateIconImage(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func updateIconImage(index: Int)
    func delete(_ modelObject: ProfileModelObject)
}

struct ProfileModel: ProfileModelInput {
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

    func fetch() -> AnyPublisher<[ProfileModelObject], AppError> {
        storage
            .publisher()
            .dropFirst()
            .mapError { errorConverter.convert(.coreData($0)) }
            .map { $0.map { profileConverter.convert($0) } }
            .eraseToAnyPublisher()
    }

    func find(identifier: String) -> AnyPublisher<ProfileModelObject, AppError> {
        storage
            .publisher()
            .dropFirst()
            .mapError { AppError(dataError: .coreData($0)) }
            .compactMap {
                $0.compactMap { profileConverter.convert($0) }
                    .filter { $0.identifier == identifier }
                    .first
            }
            .eraseToAnyPublisher()
    }

    func createBasic(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        storage
            .create()
            .handleEvents(receiveOutput: {
                modelObject.insertBasic($0, isNew: true)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func updateBasic(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        storage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                modelObject.insertBasic($0, isNew: false)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func insertSkill(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        storage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                modelObject.insertSkill($0)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func deleteSkill(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        storage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                $0.object.skill = nil
                $0.context.saveIfNeeded()
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func createProject(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        storage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                modelObject.insertProject($0)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func updateProject(
        _ modelObject: ProfileModelObject,
        identifier: String
    ) -> AnyPublisher<Void, Never> {
        storage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                modelObject.updateProject($0, identifier: identifier)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func deleteProject(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        storage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                $0.object.projects = nil
                $0.context.saveIfNeeded()
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func updateIconImage(_ modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        storage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                modelObject.insertIconImage($0)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func updateIconImage(index: Int) {
        DataHolder.profileIcon = .init(rawValue: index) ?? .penguin
    }

    func delete(_ modelObject: ProfileModelObject) {
        storage.delete(identifier: modelObject.identifier)
    }
}
