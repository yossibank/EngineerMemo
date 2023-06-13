import Combine

/// @mockable
protocol MemoModelInput: Model {
    func fetch(completion: @escaping (Result<[MemoModelObject], AppError>) -> Void)
    func find(identifier: String, completion: @escaping (Result<MemoModelObject, AppError>) -> Void)
    func create(modelObject: MemoModelObject)
    func update(modelObject: MemoModelObject)
    func delete(modelObject: MemoModelObject)
}

final class MemoModel: MemoModelInput {
    private var cancellables = Set<AnyCancellable>()

    private let storage = CoreDataStorage<Memo>()
    private let memoConverter: MemoConverterInput
    private let errorConverter: AppErrorConverterInput

    init(
        memoConverter: MemoConverterInput,
        errorConverter: AppErrorConverterInput
    ) {
        self.memoConverter = memoConverter
        self.errorConverter = errorConverter
    }

    func fetch(completion: @escaping (Result<[MemoModelObject], AppError>) -> Void) {
        storage.publisher().sink(
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
                    self?.memoConverter.convert($0)
                }
                completion(.success(modelObjects))
            }
        )
        .store(in: &cancellables)
    }

    func find(
        identifier: String,
        completion: @escaping (Result<MemoModelObject, AppError>) -> Void
    ) {
        storage.publisher().sink(
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

                let modelObject = self.memoConverter.convert(value)
                completion(.success(modelObject))
            }
        )
        .store(in: &cancellables)
    }

    func create(modelObject: MemoModelObject) {
        storage.create().sink { profile in
            modelObject.dataInsert(
                profile,
                isNew: true
            )
        }
        .store(in: &cancellables)
    }

    func update(modelObject: MemoModelObject) {
        storage.update(identifier: modelObject.identifier).sink { profile in
            modelObject.dataInsert(
                profile,
                isNew: false
            )
        }
        .store(in: &cancellables)
    }

    func delete(modelObject: MemoModelObject) {
        storage.delete(identifier: modelObject.identifier)
    }
}
