#if DEBUG
    @testable import EngineerMemo
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    final class APIClientTest: XCTestCase {
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

        func test_受け取ったステータスコードが300台の時にステータスコードエラーを受け取れること() {
            // arrange
            stub(condition: isPath("/posts")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_get.json",
                        type(of: self)
                    )!,
                    status: 302,
                    headers: ["Content-Type": "application/json"]
                )
            }

            apiClient.request(
                item: DebugGetRequest(parameters: .init(userId: nil))
            ) {
                switch $0 {
                case .success:
                    XCTFail("failed test")

                case let .failure(error):
                    // assert
                    XCTAssertEqual(
                        error,
                        .invalidStatusCode(302)
                    )
                }

                self.expectation.fulfill()
            }

            wait(for: [expectation], timeout: 0.1)
        }

        func test_受け取ったステータスコードが400台の時にステータスコードエラーを受け取れること() {
            // arrange
            stub(condition: isPath("/posts")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_get.json",
                        type(of: self)
                    )!,
                    status: 404,
                    headers: ["Content-Type": "application/json"]
                )
            }

            apiClient.request(
                item: DebugGetRequest(parameters: .init(userId: nil))
            ) {
                switch $0 {
                case .success:
                    XCTFail("failed test")

                case let .failure(error):
                    // assert
                    XCTAssertEqual(
                        error,
                        .invalidStatusCode(404)
                    )
                }

                self.expectation.fulfill()
            }

            wait(for: [expectation], timeout: 0.1)
        }

        func test_受け取ったステータスコードが500台の時にステータスコードエラーを受け取れること() {
            // arrange
            stub(condition: isPath("/posts")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_get.json",
                        type(of: self)
                    )!,
                    status: 500,
                    headers: ["Content-Type": "application/json"]
                )
            }

            apiClient.request(
                item: DebugGetRequest(parameters: .init(userId: nil))
            ) {
                switch $0 {
                case .success:
                    XCTFail("failed test")

                case let .failure(error):
                    // assert
                    XCTAssertEqual(
                        error,
                        .invalidStatusCode(500)
                    )
                }

                self.expectation.fulfill()
            }

            wait(for: [expectation], timeout: 0.1)
        }
    }
#endif
