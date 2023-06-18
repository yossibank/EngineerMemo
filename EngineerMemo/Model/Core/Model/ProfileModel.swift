import Combine

/// @mockable
protocol ProfileModelInput: Model {
    func fetch(completion: @escaping (Result<[ProfileModelObject], AppError>) -> Void)
    func find(identifier: String, completion: @escaping (Result<ProfileModelObject, AppError>) -> Void)
    func create(modelObject: ProfileModelObject)
    func basicUpdate(modelObject: ProfileModelObject)
    func skillUpdate(modelObject: ProfileModelObject)
    func projectUpdate(modelObject: ProfileModelObject)
    func iconImageUpdate(modelObject: ProfileModelObject)
    func iconImageUpdate(index: Int)
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

    func create(modelObject: ProfileModelObject) {
        profileStorage.create().sink {
            modelObject.basicInsert(
                $0.object,
                isNew: true
            )

            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }

    func basicUpdate(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink {
            modelObject.basicInsert(
                $0.object,
                isNew: false
            )

            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }

    func skillUpdate(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink { [weak self] data in
            guard let self else {
                return
            }

            if let skill = modelObject.skill {
                if data.object.skill.isNil {
                    self.skillStorage.create().sink {
                        modelObject.skill?.skillInsert(
                            $0.object,
                            isNew: true
                        )
                        data.object.skill = $0.object
                        $0.context.saveIfNeeded()
                    }
                    .store(in: &self.cancellables)
                } else {
                    self.skillStorage.update(identifier: skill.identifier).sink {
                        modelObject.skill?.skillInsert(
                            $0.object,
                            isNew: false
                        )
                        data.object.skill = $0.object
                        $0.context.saveIfNeeded()
                    }
                    .store(in: &self.cancellables)
                }
            } else {
                guard data.object.skill != nil else {
                    return
                }

                data.object.skill = nil
            }

            data.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }

    func projectUpdate(modelObject: ProfileModelObject) {
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
                        $0.projectInsert(
                            project.object,
                            isNew: true
                        )
                    }
                    data.object.addToProjects(project.object)
                    project.context.saveIfNeeded()
                }
                .store(in: &self.cancellables)
            }

            data.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }

    func iconImageUpdate(modelObject: ProfileModelObject) {
        profileStorage.update(identifier: modelObject.identifier).sink {
            modelObject.iconImageInsert($0.object)
            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }

    func iconImageUpdate(index: Int) {
        DataHolder.profileIcon = .init(rawValue: index) ?? .penguin
    }

    func delete(modelObject: ProfileModelObject) {
        profileStorage.delete(identifier: modelObject.identifier)
    }
}
