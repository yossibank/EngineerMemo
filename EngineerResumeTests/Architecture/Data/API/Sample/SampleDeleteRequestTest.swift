@testable import EngineerResume
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

final class SampleDeleteRequestTest: XCTestCase {
    private var apiClient: APIClient!

    override func setUp() {
        super.setUp()

        apiClient = .init()
    }

    override func tearDown() {
        super.tearDown()

        HTTPStubs.removeAllStubs()
    }

    func test_delete_成功_正常系のレスポンスを取得できること() {
        // arrange
        let expectation = XCTestExpectation(description: #function)

        stub(condition: isPath("/posts/1")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "success_sample_delete.json",
                    type(of: self)
                )!,
                headers: ["Content-Type": "application/json"]
            )
        }

        // act
        apiClient.request(
            item: SampleDeleteRequest(pathComponent: 1)
        ) {
            switch $0 {
            case let .success(dataObject):
                // assert
                XCTAssertNotNil(dataObject)

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
}
