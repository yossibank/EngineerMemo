@testable import EngineerMemo
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

final class SampleGetRequestTest: XCTestCase {
    private var apiClient: APIClient!

    override func setUp() {
        super.setUp()

        apiClient = .init()
    }

    override func tearDown() {
        super.tearDown()

        HTTPStubs.removeAllStubs()
    }

    func test_get_成功_正常系のレスポンスを取得できること() {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        stub(condition: isPath("/posts")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "success_sample_get.json",
                    type(of: self)
                )!,
                headers: ["Content-Type": "application/json"]
            )
        }

        // act
        apiClient.request(
            item: SampleGetRequest(parameters: .init(userId: nil))
        ) {
            switch $0 {
            case let .success(dataObject):
                // assert
                XCTAssertNotNil(dataObject)
                XCTAssertEqual(dataObject.count, 100)
                XCTAssertEqual(dataObject.first!.userId, 1)

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func test_get_デコード失敗_エラーを取得できること() {
        // arrange
        let expectation = XCTestExpectation(description: "通信待機")

        stub(condition: isPath("/posts")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "failure_sample_get.json",
                    type(of: self)
                )!,
                headers: ["Content-Type": "application/json"]
            )
        }

        // act
        apiClient.request(
            item: SampleGetRequest(parameters: .init(userId: nil))
        ) {
            switch $0 {
            case .success:
                XCTFail()

            case let .failure(error):
                // assert
                XCTAssertEqual(error, .decodeError)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
}
