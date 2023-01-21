@testable import EngineerMemo
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

final class APIClientTest: XCTestCase {
    private var apiClient: APIClient!

    override func setUp() {
        super.setUp()

        apiClient = .init()
    }

    override func tearDown() {
        super.tearDown()

        HTTPStubs.removeAllStubs()
    }

    func test_受け取ったステータスコードが300台の際にステータスコードエラーを受け取れること() {
        let expectation = XCTestExpectation(description: #function)

        stub(condition: isPath("/posts")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "success_sample_get.json",
                    type(of: self)
                )!,
                status: 302,
                headers: ["Content-Type": "application/json"]
            )
        }

        apiClient.request(
            item: SampleGetRequest(parameters: .init(userId: nil))
        ) {
            switch $0 {
            case .success:
                XCTFail()

            case let .failure(error):
                // assert
                XCTAssertEqual(error, .invalidStatusCode(302))
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func test_受け取ったステータスコードが400台の際にステータスコードエラーを受け取れること() {
        let expectation = XCTestExpectation(description: #function)

        stub(condition: isPath("/posts")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "success_sample_get.json",
                    type(of: self)
                )!,
                status: 404,
                headers: ["Content-Type": "application/json"]
            )
        }

        apiClient.request(
            item: SampleGetRequest(parameters: .init(userId: nil))
        ) {
            switch $0 {
            case .success:
                XCTFail()

            case let .failure(error):
                // assert
                XCTAssertEqual(error, .invalidStatusCode(404))
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func test_受け取ったステータスコードが500台の際にステータスコードエラーを受け取れること() {
        let expectation = XCTestExpectation(description: #function)

        stub(condition: isPath("/posts")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "success_sample_get.json",
                    type(of: self)
                )!,
                status: 500,
                headers: ["Content-Type": "application/json"]
            )
        }

        apiClient.request(
            item: SampleGetRequest(parameters: .init(userId: nil))
        ) {
            switch $0 {
            case .success:
                XCTFail()

            case let .failure(error):
                // assert
                XCTAssertEqual(error, .invalidStatusCode(500))
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
}
