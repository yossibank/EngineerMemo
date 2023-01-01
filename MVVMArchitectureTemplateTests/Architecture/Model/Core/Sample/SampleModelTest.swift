@testable import MVVMArchitectureTemplate
import XCTest

final class SampleModelTest: XCTestCase {
    private var apiClient: APIClientInputMock!
    private var sampleConverter: SampleConverterInputMock!
    private var errorConverter: AppErrorConverterInputMock!
    private var model: SampleModel!

    override func setUp() {
        super.setUp()

        apiClient = .init()
        sampleConverter = .init()
        errorConverter = .init()
        model = .init(
            apiClient: apiClient,
            sampleConverter: sampleConverter,
            errorConverter: errorConverter
        )
    }

    func test_get_成功_情報を取得できること() throws {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        apiClient.requestHandler = { request, completion in
            // assert
            XCTAssertTrue(request is SampleGetRequest)

            if let completion = completion as? (Result<[SampleDataObject], APIError>) -> Void {
                completion(.success([SampleDataObjectBuilder().build()]))
            }

            expectation.fulfill()
        }

        sampleConverter.convertHandler = { _ in
            [SampleModelObjectBuilder().build()]
        }

        // act
        let publisher = model.get()
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output,
            [SampleModelObjectBuilder().build()]
        )

        wait(for: [expectation], timeout: 0.1)
    }

    func test_get_失敗_エラーを取得できること() throws {
        // arrange
        apiClient.requestHandler = { _, completion in
            if let completion = completion as? (Result<[SampleDataObject], APIError>) -> Void {
                completion(.failure(.urlSessionError))
            }
        }

        errorConverter.convertHandler = { error in
            AppErrorBuilder().error(error).build()
        }

        // act
        let publisher = model.get()
        let result = try awaitResultPublisher(publisher)

        switch result {
        case .success:
            XCTFail()

        case let .failure(error):
            // assert
            XCTAssertEqual(
                error as! AppError,
                .init(error: .urlSessionError)
            )
        }
    }

    func test_post_成功_情報を取得できること() throws {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        apiClient.requestHandler = { request, completion in
            // assert
            XCTAssertTrue(request is SamplePostRequest)

            if let completion = completion as? (Result<SampleDataObject, APIError>) -> Void {
                completion(.success(SampleDataObjectBuilder().build()))
            }

            expectation.fulfill()
        }

        sampleConverter.convertObjectHandler = { _ in
            SampleModelObjectBuilder().build()
        }

        // act
        let parameters = SamplePostRequest.Parameters(userId: 1, title: "title", body: "body")
        let publisher = model.post(parameters: parameters)
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output,
            SampleModelObjectBuilder().build()
        )

        wait(for: [expectation], timeout: 0.1)
    }

    func test_post_失敗_エラーを取得できること() throws {
        // arrange
        apiClient.requestHandler = { _, completion in
            if let completion = completion as? (Result<SampleDataObject, APIError>) -> Void {
                completion(.failure(.invalidStatusCode(400)))
            }
        }

        errorConverter.convertHandler = { error in
            AppErrorBuilder().error(error).build()
        }

        // act
        let parameters = SamplePostRequest.Parameters(userId: 1, title: "title", body: "body")
        let publisher = model.post(parameters: parameters)
        let result = try awaitResultPublisher(publisher)

        switch result {
        case .success:
            XCTFail()

        case let .failure(error):
            // assert
            XCTAssertEqual(
                error as! AppError,
                .init(error: .invalidStatusCode(400))
            )
        }
    }

    func test_put_成功_情報を取得できること() throws {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        apiClient.requestHandler = { request, completion in
            XCTAssertTrue(request is SamplePutRequest)

            if let completion = completion as? (Result<SampleDataObject, APIError>) -> Void {
                completion(.success(SampleDataObjectBuilder().build()))
            }

            expectation.fulfill()
        }

        sampleConverter.convertObjectHandler = { _ in
            SampleModelObjectBuilder().build()
        }

        // act
        let parameters = SamplePutRequest.Parameters(userId: 1, id: 1, title: "title", body: "body")
        let publisher = model.put(userId: 1, parameters: parameters)
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertEqual(
            output,
            SampleModelObjectBuilder().build()
        )

        wait(for: [expectation], timeout: 0.1)
    }

    func test_put_失敗_エラーを取得できること() throws {
        // arrange
        apiClient.requestHandler = { _, completion in
            if let completion = completion as? (Result<SampleDataObject, APIError>) -> Void {
                completion(.failure(.emptyResponse))
            }
        }

        errorConverter.convertHandler = { error in
            AppErrorBuilder().error(error).build()
        }

        // act
        let parameters = SamplePutRequest.Parameters(userId: 1, id: 1, title: "title", body: "body")
        let publisher = model.put(userId: 1, parameters: parameters)
        let result = try awaitResultPublisher(publisher)

        switch result {
        case .success:
            XCTFail()

        case let .failure(error):
            // assert
            XCTAssertEqual(
                error as! AppError,
                .init(error: .emptyResponse)
            )
        }
    }

    func test_delete_成功_情報を取得できること() throws {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        apiClient.requestHandler = { request, completion in
            // assert
            XCTAssertTrue(request is SampleDeleteRequest)

            if let completion = completion as? (Result<EmptyResponse, APIError>) -> Void {
                completion(.success(.init()))
            }

            expectation.fulfill()
        }

        // act
        let publisher = model.delete(userId: 1)
        let output = try awaitOutputPublisher(publisher)

        // assert
        XCTAssertTrue(output)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_delete_失敗_エラーを取得できること() throws {
        // arrange
        apiClient.requestHandler = { _, completion in
            if let completion = completion as? (Result<EmptyResponse, APIError>) -> Void {
                completion(.failure(.invalidRequest))
            }
        }

        errorConverter.convertHandler = { error in
            AppErrorBuilder().error(error).build()
        }

        // act
        let publisher = model.delete(userId: 1)
        let result = try awaitResultPublisher(publisher)

        switch result {
        case .success:
            XCTFail()

        case let .failure(error):
            // assert
            XCTAssertEqual(
                error as! AppError,
                .init(error: .invalidRequest)
            )
        }
    }
}
