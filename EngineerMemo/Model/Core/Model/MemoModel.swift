import Combine

/// @mockable
protocol MemoModelInput: Model {
    func fetch() -> AnyPublisher<[MemoModelObject], AppError>
    func find(identifier: String) -> AnyPublisher<MemoModelObject, AppError>
    func create(_ modelObject: MemoModelObject) -> AnyPublisher<Void, Never>
    func update(_ modelObject: MemoModelObject) -> AnyPublisher<Void, Never>
    func delete(_ modelObject: MemoModelObject)
}

struct MemoModel: MemoModelInput {
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

    func fetch() -> AnyPublisher<[MemoModelObject], AppError> {
        storage
            .publisher()
            .mapError { errorConverter.convert(.coreData($0)) }
            .map { $0.map { memoConverter.convert($0) } }
            .eraseToAnyPublisher()
    }

    func find(identifier: String) -> AnyPublisher<MemoModelObject, AppError> {
        storage
            .publisher()
            .mapError { errorConverter.convert(.coreData($0)) }
            .compactMap {
                $0.compactMap { memoConverter.convert($0) }
                    .filter { $0.identifier == identifier }
                    .first
            }
            .eraseToAnyPublisher()
    }

    func create(_ modelObject: MemoModelObject) -> AnyPublisher<Void, Never> {
        storage
            .create()
            .handleEvents(receiveOutput: {
                modelObject.insertMemo($0, isNew: true)
                WidgetConfig.reload()
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func update(_ modelObject: MemoModelObject) -> AnyPublisher<Void, Never> {
        storage
            .update(identifier: modelObject.identifier)
            .handleEvents(receiveOutput: {
                modelObject.insertMemo($0, isNew: false)
                WidgetConfig.reload()
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func delete(_ modelObject: MemoModelObject) {
        storage.delete(identifier: modelObject.identifier)
    }
}
