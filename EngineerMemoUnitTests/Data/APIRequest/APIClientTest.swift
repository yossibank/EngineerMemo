#if DEBUG
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

            wait { expectation in
                // act
                self.apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil))) {
                    if case let .failure(error) = $0 {
                        // assert
                        XCTAssertEqual(
                            error,
                            .invalidStatusCode(302)
                        )

                        expectation.fulfill()
                    }
                }
            }
        }

        func test_publisher_受け取ったステータスコードが300台の時にステータスコードエラーを受け取れること() {
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

            do {
                let publisher = apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))

                // act
                _ = try awaitOutputPublisher(publisher)
            } catch {
                // assert
                XCTAssertEqual(
                    error as! APIError,
                    .invalidStatusCode(302)
                )
            }
        }

        func test_async_受け取ったステータスコードが300台の時にステータスコードエラーを受け取れること() async {
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

            do {
                // act
                _ = try await apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))
            } catch {
                // assert
                XCTAssertEqual(
                    error as! APIError,
                    .invalidStatusCode(302)
                )
            }
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

            wait { expectation in
                // act
                self.apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil))) {
                    if case let .failure(error) = $0 {
                        // assert
                        XCTAssertEqual(
                            error,
                            .invalidStatusCode(404)
                        )

                        expectation.fulfill()
                    }
                }
            }
        }

        func test_publisher_受け取ったステータスコードが400台の時にステータスコードエラーを受け取れること() {
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

            do {
                let publisher = apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))

                // act
                _ = try awaitOutputPublisher(publisher)
            } catch {
                // assert
                XCTAssertEqual(
                    error as! APIError,
                    .invalidStatusCode(404)
                )
            }
        }

        func test_async_受け取ったステータスコードが400台の時にステータスコードエラーを受け取れること() async {
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

            do {
                // act
                _ = try await apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))
            } catch {
                // assert
                XCTAssertEqual(
                    error as! APIError,
                    .invalidStatusCode(404)
                )
            }
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

            wait { expectation in
                // act
                self.apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil))) {
                    if case let .failure(error) = $0 {
                        // assert
                        XCTAssertEqual(
                            error,
                            .invalidStatusCode(500)
                        )

                        expectation.fulfill()
                    }
                }
            }
        }

        func test_publisher_受け取ったステータスコードが500台の時にステータスコードエラーを受け取れること() throws {
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

            do {
                let publisher = apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))

                // act
                _ = try awaitOutputPublisher(publisher)
            } catch {
                // assert
                XCTAssertEqual(
                    error as! APIError,
                    .invalidStatusCode(500)
                )
            }
        }

        func test_async_受け取ったステータスコードが500台の時にステータスコードエラーを受け取れること() async {
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

            do {
                // act
                _ = try await apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))
            } catch {
                // assert
                XCTAssertEqual(
                    error as! APIError,
                    .invalidStatusCode(500)
                )
            }
        }
    }
#endif
