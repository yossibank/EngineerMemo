#if DEBUG
    @testable import EngineerMemo
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    final class DebugDeleteRequestTest: XCTestCase {
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

        func test_delete_成功_正常系のレスポンスを取得できること() {
            // arrange
            stub(condition: isPath("/posts/1")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_delete.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            // act
            apiClient.request(
                item: DebugDeleteRequest(pathComponent: 1)
            ) {
                switch $0 {
                case let .success(dataObject):
                    // assert
                    XCTAssertNotNil(dataObject)

                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }

                self.expectation.fulfill()
            }

            wait(for: [expectation], timeout: 0.1)
        }
    }
#endif
