#if DEBUG
    @testable import EngineerMemo
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    final class DebugPostRequestTest: XCTestCase {
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

        func test_post_成功_正常系のレスポンスを取得できること() {
            // arrange
            stub(condition: isPath("/posts")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_post.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            // act
            apiClient.request(
                item: DebugPostRequest(parameters: .init(
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

                self.expectation.fulfill()
            }

            wait(for: [expectation], timeout: 0.1)
        }

        func test_post_デコード失敗_エラーを取得できること() {
            // arrange
            stub(condition: isPath("/posts")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "failure_debug_post.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            // act
            apiClient.request(
                item: DebugPostRequest(parameters: .init(
                    userId: 1,
                    title: "sample title",
                    body: "sample body"
                ))
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
