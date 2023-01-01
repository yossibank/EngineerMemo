import Combine
import XCTest

extension XCTestCase {
    func awaitResultPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 2.0,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Result<T.Output, Error> {
        var result: Result<T.Output, Error>?

        let expectation = expectation(description: "Awaiting Publisher")
        let cancellable = publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        result = .failure(error)

                    case .finished:
                        break
                    }

                    expectation.fulfill()
                },
                receiveValue: { value in
                    result = .success(value)
                }
            )

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any product",
            file: file,
            line: line
        )

        return unwrappedResult
    }

    func awaitOutputPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 2.0,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?

        let expectation = expectation(description: "Awaiting Publisher")
        let cancellable = publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        result = .failure(error)

                    case .finished:
                        break
                    }

                    expectation.fulfill()
                },
                receiveValue: { value in
                    result = .success(value)
                }
            )

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any product",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
