import Combine

/// @mockable
protocol ProfileModelInput: Model {
    func fetch() -> AnyPublisher<[ProfileModelObject], AppError>
    func find(identifier: String, completion: @escaping (Result<ProfileModelObject, AppError>) -> Void)
    func create(modelObject: ProfileModelObject)
    func update(modelObject: ProfileModelObject)
    func updateSkill(modelObject: ProfileModelObject)
    func createProject(_ modelObject: ProfileModelObject, project: ProjectModelObject)
    func updateProject(_ modelObject: ProfileModelObject, project: ProjectModelObject?)
    func updateIconImage(modelObject: ProfileModelObject)
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
        create {
            modelObject.insertBasic($0, isNew: true)
        }
    }

    func update(modelObject: ProfileModelObject) {
        update(modelObject: modelObject) {
            modelObject.insertBasic($0, isNew: false)
        }
    }

    func createSkill(modelObject: ProfileModelObject) {
        update(modelObject: modelObject) { _ in }
    }

    func updateSkill(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink { [weak self] profile in
            guard let skill = modelObject.skill else {
                self?.deleteSkill(profile: profile)
                return
            }

            self?.updateSkill(skill, profile: profile)
        }
        .store(in: &cancellables)
    }

    func createProject(
        _ modelObject: ProfileModelObject,
        project: ProjectModelObject
    ) {
        profileStorage.update(identifier: modelObject.identifier).sink { [weak self] profile in
            self?.createProject(
                project: project,
                profile: profile
            )
        }
        .store(in: &cancellables)
    }

    func updateProject(
        _ modelObject: ProfileModelObject,
        project: ProjectModelObject? = nil
    ) {
        profileStorage.update(identifier: modelObject.identifier).sink { [weak self] profile in
            guard !modelObject.projects.isEmpty else {
                self?.deleteProject(profile: profile)
                return
            }

            self?.createProject(
                project: project,
                profile: profile
            )
        }
        .store(in: &cancellables)
    }

    func updateIconImage(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink {
            modelObject.insertIconImage($0)
        }
        .store(in: &cancellables)
    }

    func updateIconImage(index: Int) {
        DataHolder.profileIcon = .init(rawValue: index) ?? .penguin
    }

    func delete(modelObject: ProfileModelObject) {
        profileStorage.delete(identifier: modelObject.identifier)
    }
}

// MARK: - private methods

private extension ProfileModel {
    func create(completion: @escaping (CoreDataObject<Profile>) -> Void) {
        profileStorage.create().sink {
            completion($0)
        }
        .store(in: &cancellables)
    }

    func update(
        modelObject: ProfileModelObject,
        completion: @escaping (CoreDataObject<Profile>) -> Void
    ) {
        profileStorage.update(identifier: modelObject.identifier).sink {
            completion($0)
        }
        .store(in: &cancellables)
    }

    func createSkill(
        modelObject: SkillModelObject,
        profile: CoreDataObject<Profile>
    ) {
        skillStorage.create().sink {
            modelObject.insertSkill(
                profile: profile,
                skill: $0,
                isNew: true
            )
        }
        .store(in: &cancellables)
    }

    func updateSkill(
        _ modelObject: SkillModelObject,
        profile: CoreDataObject<Profile>
    ) {
        if profile.object.skill.isNil {
            skillStorage.create().sink {
                modelObject.insertSkill(
                    profile: profile,
                    skill: $0,
                    isNew: true
                )
            }
            .store(in: &cancellables)
        } else {
            skillStorage.update(identifier: profile.object.skill?.identifier ?? .empty).sink {
                modelObject.insertSkill(
                    profile: profile,
                    skill: $0,
                    isNew: false
                )
            }
            .store(in: &cancellables)
        }
    }

    func deleteSkill(profile: CoreDataObject<Profile>) {
        profile.object.skill = nil
        profile.context.saveIfNeeded()
    }

    func createProject(
        project: ProjectModelObject? = nil,
        profile: CoreDataObject<Profile>
    ) {
        projectStorage.create().sink {
            project?.insertProject(
                profile: profile,
                project: $0,
                isNew: true
            )
        }
        .store(in: &cancellables)
    }

    func deleteProject(profile: CoreDataObject<Profile>) {
        profile.object.projects = nil
        profile.context.saveIfNeeded()
    }
}
