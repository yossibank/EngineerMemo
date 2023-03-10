@testable import EngineerMemo
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

final class ___FILEBASENAME___: XCTestCase {
    private var apiClient: APIClient!
    private var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()

        apiClient = .init()
        expectation = .init()
    }

    override func tearDown() {
        super.tearDown()

        HTTPStubs.removeAllStubs()
    }

    func test_HTTPMethod_成功_正常系のレスポンスを取得できること() {
        // arrange
        stub(condition: isPath("/スタブパス")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "スタブ.json",
                    type(of: self)
                )!,
                headers: ["Content-Type": "application/json"]
            )
        }

        // act
        apiClient.request(
            item: // APIリクエスト
        ) {
            switch $0 {
            case let .success(dataObject):
                // assert
                XCTAssertEqual(
                    dataObject,
                    // DataObjectBuilder
                )

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func test_HTTPMethod_デコード失敗_エラーを取得できること() {
        // arrange
        stub(condition: isPath("/スタブパス")) { _ in
            fixture(
                filePath: OHPathForFile(
                    "スタブ.json",
                    type(of: self)
                )!,
                headers: ["Content-Type": "application/json"]
            )
        }

        // act
        apiClient.request(
            item: // APIリクエスト
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
