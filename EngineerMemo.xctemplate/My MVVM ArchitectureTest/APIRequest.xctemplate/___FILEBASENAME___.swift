@testable import EngineerMemo
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

final class ___FILEBASENAME___: XCTestCase {
    private var apiClient: APIClient!

    override func setUp() {
        super.setUp()

        apiClient = .init()
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

        wait { expectation in
            // act
            self.apiClient.request(
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
        }
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

        wait { expectation in
            // act
            apiClient.request(
                item: // APIリクエスト
            ) {
                if case let .failure(error) = $0 {
                    // assert
                    XCTAssertEqual(
                        error,
                        .decodeError
                    )

                    expectation.fulfill()
                }
            }
        }
    }
}
