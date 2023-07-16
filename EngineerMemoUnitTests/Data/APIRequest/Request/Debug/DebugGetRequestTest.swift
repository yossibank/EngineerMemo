#if DEBUG
    @testable import EngineerMemo
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    final class DebugGetRequestTest: XCTestCase {
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
            stub(condition: isPath("/posts")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_get.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            wait { expectation in
                // act
                self.apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil))) {
                    switch $0 {
                    case let .success(dataObject):
                        // assert
                        XCTAssertEqual(dataObject.count, 100)
                        XCTAssertEqual(dataObject.first!.userId, 1)

                    case let .failure(error):
                        XCTFail(error.localizedDescription)
                    }

                    expectation.fulfill()
                }
            }
        }

        func test_publisher_get_成功_正常系のレスポンスを取得できること() throws {
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
            let publisher = apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))
            let output = try awaitOutputPublisher(publisher)

            // assert
            XCTAssertEqual(output.count, 100)
            XCTAssertEqual(output.first!.userId, 1)
        }

        func test_async_get_成功_正常系のレスポンスを取得できること() async throws {
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
            let output = try await apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))

            // assert
            XCTAssertEqual(output.count, 100)
            XCTAssertEqual(output.first!.userId, 1)
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

            wait { expectation in
                // act
                self.apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil))) {
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

        func test_publisher_get_デコード失敗_エラーを取得できること() {
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

            do {
                let publisher = apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))

                // act
                _ = try awaitOutputPublisher(publisher)
            } catch {
                // assert
                XCTAssertEqual(
                    error as! APIError,
                    .decodeError
                )
            }
        }

        func test_async_get_デコード失敗_エラーを取得できること() async {
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

            do {
                // act
                _ = try await apiClient.request(item: DebugGetRequest(parameters: .init(userId: nil)))
            } catch {
                // assert
                XCTAssertEqual(
                    error as! APIError,
                    .decodeError
                )
            }
        }
    }
#endif
