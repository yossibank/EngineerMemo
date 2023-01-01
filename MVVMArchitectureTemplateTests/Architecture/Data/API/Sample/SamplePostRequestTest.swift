@testable import MVVMArchitectureTemplate
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

final class SamplePostRequestTest: XCTestCase {
    private var apiClient: APIClient!

    override func setUp() {
        super.setUp()

        apiClient = .init()
    }

    override func tearDown() {
        super.tearDown()

        HTTPStubs.removeAllStubs()
    }

    func test_post_成功_正常系のレスポンスを取得できること() {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        stub(condition: isPath("/posts")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "success_sample_post.json",
                    type(of: self)
                )!,
                headers: ["Content-Type": "application/json"]
            )
        }

        // act
        apiClient.request(
            item: SamplePostRequest(parameters: .init(
                userId: 1,
                title: "sample title",
                body: "sample body"
            ))
        ) {
            switch $0 {
            case let .success(dataObject):
                // assert
                XCTAssertNotNil(dataObject)
                XCTAssertEqual(dataObject.userId, 1)
                XCTAssertEqual(dataObject.title, "sample title")
                XCTAssertEqual(dataObject.body, "sample body")

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func test_post_デコード失敗_エラーを取得できること() {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        stub(condition: isPath("/posts")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "failure_sample_post.json",
                    type(of: self)
                )!,
                headers: ["Content-Type": "application/json"]
            )
        }

        // act
        apiClient.request(
            item: SamplePostRequest(parameters: .init(
                userId: 1,
                title: "sample title",
                body: "sample body"
            ))
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
