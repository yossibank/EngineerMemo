import Combine

/// @mockable
protocol SampleModelInput: Model {
    func get(
        userId: Int?
    ) -> AnyPublisher<[SampleModelObject], AppError>

    func post(
        parameters: SamplePostRequest.Parameters
    ) -> AnyPublisher<SampleModelObject, AppError>

    func put(
        userId: Int,
        parameters: SamplePutRequest.Parameters
    ) -> AnyPublisher<SampleModelObject, AppError>

    func delete(
        userId: Int
    ) -> AnyPublisher<Bool, AppError>
}

struct SampleModel: SampleModelInput {
    private let apiClient: APIClientInput
    private let sampleConverter: SampleConverterInput
    private let errorConverter: AppErrorConverterInput

    init(
        apiClient: APIClientInput,
        sampleConverter: SampleConverterInput,
        errorConverter: AppErrorConverterInput
    ) {
        self.apiClient = apiClient
        self.sampleConverter = sampleConverter
        self.errorConverter = errorConverter
    }

    func get(
        userId: Int? = nil
    ) -> AnyPublisher<[SampleModelObject], AppError> {
        toPublisher { promise in
            apiClient.request(
                item: SampleGetRequest(parameters: .init(userId: userId))
            ) {
                switch $0 {
                case let .success(dataObject):
                    let modelObject = sampleConverter.convert(dataObject)
                    promise(.success(modelObject))

                case let .failure(apiError):
                    let appError = errorConverter.convert(apiError)
                    promise(.failure(appError))
                }
            }
        }
    }

    func post(
        parameters: SamplePostRequest.Parameters
    ) -> AnyPublisher<SampleModelObject, AppError> {
        toPublisher { promise in
            apiClient.request(
                item: SamplePostRequest(parameters: parameters)
            ) {
                switch $0 {
                case let .success(dataObject):
                    let modelObject = sampleConverter.convert(dataObject)
                    promise(.success(modelObject))

                case let .failure(apiError):
                    let appError = errorConverter.convert(apiError)
                    promise(.failure(appError))
                }
            }
        }
    }

    func put(
        userId: Int,
        parameters: SamplePutRequest.Parameters
    ) -> AnyPublisher<SampleModelObject, AppError> {
        toPublisher { promise in
            apiClient.request(
                item: SamplePutRequest(
                    parameters: parameters,
                    pathComponent: userId
                )
            ) {
                switch $0 {
                case let .success(dataObject):
                    let modelObject = sampleConverter.convert(dataObject)
                    promise(.success(modelObject))

                case let .failure(apiError):
                    let appError = errorConverter.convert(apiError)
                    promise(.failure(appError))
                }
            }
        }
    }

    func delete(
        userId: Int
    ) -> AnyPublisher<Bool, AppError> {
        toPublisher { promise in
            apiClient.request(
                item: SampleDeleteRequest(pathComponent: userId)
            ) {
                switch $0 {
                case .success:
                    promise(.success(true))

                case let .failure(apiError):
                    let appError = errorConverter.convert(apiError)
                    promise(.failure(appError))
                }
            }
        }
    }
}
