import Combine

/// @mockable
protocol ProfileModelInput: Model {
    func fetch() -> AnyPublisher<[ProfileModelObject], AppError>
    func find(identifier: String) -> AnyPublisher<ProfileModelObject, AppError>
    func createBasic(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func updateBasic(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func createSkill(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func updateSkill(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func deleteSkill(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func createProject(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func deleteProject(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func updateIconImage(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never>
    func updateIconImage(index: Int)
    func delete(modelObject: ProfileModelObject)
}

final class ProfileModel: ProfileModelInput {
    private var cancellables = Set<AnyCancellable>()

    private let profileStorage = CoreDataStorage<Profile>()
    private let skillStorage = CoreDataStorage<Skill>()
    private let projectStorage = CoreDataStorage<Project>()

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
        profileStorage
            .publisher()
            .dropFirst()
            .mapError {
                AppError(dataError: .coreData($0))
            }
            .map { [weak self] in
                $0.compactMap {
                    self?.profileConverter.convert($0)
                }
            }
            .eraseToAnyPublisher()
    }

    func find(identifier: String) -> AnyPublisher<ProfileModelObject, AppError> {
        profileStorage
            .publisher()
            .dropFirst()
            .mapError {
                AppError(dataError: .coreData($0))
            }
            .compactMap { [weak self] in
                $0.compactMap { self?.profileConverter.convert($0) }
                    .filter { $0.identifier == identifier }
                    .first
            }
            .eraseToAnyPublisher()
    }

    func createBasic(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        profileStorage
            .create()
            .handleEvents(receiveOutput: {
                modelObject.insertBasic($0, isNew: true)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func updateBasic(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        profileStorage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                modelObject.insertBasic($0, isNew: false)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func createSkill(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        profileStorage
            .update(identifier: modelObject.identifier)
            .combineLatest(skillStorage.create())
            .handleEvents(receiveOutput: { profile, skill in
                modelObject.insertSkill(
                    profile: profile,
                    skill: skill,
                    isNew: true
                )
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func updateSkill(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        profileStorage
            .update(identifier: modelObject.identifier)
            .combineLatest(skillStorage.update(identifier: modelObject.skillModelObject?.identifier ?? .empty))
            .handleEvents(receiveOutput: { profile, skill in
                modelObject.insertSkill(
                    profile: profile,
                    skill: skill,
                    isNew: false
                )
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func deleteSkill(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        profileStorage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                $0.object.skill = nil
                $0.context.saveIfNeeded()
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func createProject(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        profileStorage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                modelObject.insertProject(profile: $0)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func deleteProject(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        profileStorage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                $0.object.projects = nil
                $0.context.saveIfNeeded()
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func updateIconImage(modelObject: ProfileModelObject) -> AnyPublisher<Void, Never> {
        profileStorage
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

    func delete(modelObject: ProfileModelObject) {
        profileStorage.delete(identifier: modelObject.identifier)
    }
}
