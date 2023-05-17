#if DEBUG
    @testable import EngineerMemo
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    final class DebugGetRequestTest: XCTestCase {
        private var apiClient: APIClient!
        private var expectation: XCTestExpectation!

        override func setUp() {
            super.setUp()

            apiClient = .init()
            expectation = .init(description: #function)
        }

        override func tearDown() {
            super.tearDown()

            HTTPStubs.removeAllStubs()
        }

        func test_get_成功_正常系のレスポンスを取得できること() {
            // arrange
            stub(condition: isPath("/posts")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_get.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            // act
            apiClient.request(
                item: DebugGetRequest(parameters: .init(userId: nil))
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

                self.expectation.fulfill()
            }

            wait(for: [expectation], timeout: 0.1)
        }

        func test_get_デコード失敗_エラーを取得できること() {
            // arrange
            stub(condition: isPath("/posts")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "failure_debug_get.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            // act
            apiClient.request(
                item: DebugGetRequest(parameters: .init(userId: nil))
            ) {
                if case let .failure(error) = $0 {
                    // assert
                    XCTAssertEqual(
                        error,
                        .decodeError
                    )

                    self.expectation.fulfill()
                }
            }

            wait(for: [expectation], timeout: 0.1)
        }
    }
#endif
