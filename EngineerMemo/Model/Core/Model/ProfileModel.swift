import Combine

/// @mockable
protocol ProfileModelInput: Model {
    func fetch(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void)
    func find(identifier: String, completion: @escaping (Result<ProfileModelObject, AppError>) -> Void)
    func update(modelObject: ProfileModelObject, isNew: Bool)
    func updateSkill(modelObject: ProfileModelObject)
    func updateProject(modelObject: ProfileModelObject)
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

    func update(
        modelObject: ProfileModelObject,
        isNew: Bool
    ) {
        if isNew {
            profileStorage.create().sink {
                modelObject.basicInsert($0, isNew: true)
            }
            .store(in: &cancellables)
        } else {
            profileStorage.update(identifier: modelObject.identifier).sink {
                modelObject.basicInsert($0, isNew: false)
            }
            .store(in: &cancellables)
        }
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

    func updateProject(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink { [weak self] data in
            guard let self else {
                return
            }

            if modelObject.projects.isEmpty {
                guard !data.object.projects.isEmtpy else {
                    return
                }

                data.object.projects = nil
            } else {
                self.projectStorage.create().sink { project in
                    modelObject.projects.forEach {
                        $0.projectInsert(project, isNew: true)
                    }
                    data.object.addToProjects(project.object)
                }
                .store(in: &self.cancellables)
            }

            data.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }

    func updateIconImage(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink {
            modelObject.iconImageInsert($0)
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
}
