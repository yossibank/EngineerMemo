#if DEBUG
    @testable import EngineerMemo
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    final class DebugPutRequestTest: XCTestCase {
        private var apiClient: APIClient!

        override func setUp() {
            super.setUp()

            apiClient = .init()
        }

        override func tearDown() {
            super.tearDown()

            HTTPStubs.removeAllStubs()
        }

        func test_put_成功_正常系のレスポンスを取得できること() {
            // arrange
            stub(condition: isPath("/posts/1")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_put.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            wait { expectation in
                // act
                self.apiClient.request(
                    item: DebugPutRequest(
                        parameters: .init(
                            userId: 1,
                            id: 1,
                            title: "sample title",
                            body: "sample body"
                        ),
                        pathComponent: 1
                    )
                ) {
                    switch $0 {
                    case let .success(dataObject):
                        // assert
                        XCTAssertEqual(
                            dataObject,
                            DebugDataObjectBuilder().build()
                        )

                    case let .failure(error):
                        XCTFail(error.localizedDescription)
                    }

                    expectation.fulfill()
                }
            }
        }

        func test_publisher_put_成功_正常系のレスポンスを取得できること() throws {
            // arrange
            stub(condition: isPath("/posts/1")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_put.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            let publisher = apiClient.request(
                item: DebugPutRequest(
                    parameters: .init(
                        userId: 1,
                        id: 1,
                        title: "sample title",
                        body: "sample body"
                    ),
                    pathComponent: 1
                )
            )

            let output = try awaitOutputPublisher(publisher)

            // assert
            XCTAssertEqual(
                output,
                DebugDataObjectBuilder().build()
            )
        }

        func test_async_put_成功_正常系のレスポンスを取得できること() async throws {
            // arrange
            stub(condition: isPath("/posts/1")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "success_debug_put.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            let output = try await apiClient.request(
                item: DebugPutRequest(
                    parameters: .init(
                        userId: 1,
                        id: 1,
                        title: "sample title",
                        body: "sample body"
                    ),
                    pathComponent: 1
                )
            )

            // assert
            XCTAssertEqual(
                output,
                DebugDataObjectBuilder().build()
            )
        }

        func test_put_デコード失敗_エラーを取得できること() {
            // arrange
            stub(condition: isPath("/posts/1")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "failure_debug_put.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            wait { expectation in
                // act
                self.apiClient.request(
                    item: DebugPutRequest(
                        parameters: .init(
                            userId: 1,
                            id: 1,
                            title: "sample title",
                            body: "sample body"
                        ),
                        pathComponent: 1
                    )
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

        func test_publisher_put_デコード失敗_エラーを取得できること() {
            // arrange
            stub(condition: isPath("/posts/1")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "failure_debug_put.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            do {
                let publisher = apiClient.request(
                    item: DebugPutRequest(
                        parameters: .init(
                            userId: 1,
                            id: 1,
                            title: "sample title",
                            body: "sample body"
                        ),
                        pathComponent: 1
                    )
                )

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

        func test_async_put_デコード失敗_エラーを取得できること() async {
            // arrange
            stub(condition: isPath("/posts/1")) { _ in
                fixture(
                    filePath: OHPathForFile(
                        "failure_debug_put.json",
                        type(of: self)
                    )!,
                    headers: ["Content-Type": "application/json"]
                )
            }

            do {
                // act
                _ = try await apiClient.request(
                    item: DebugPutRequest(
                        parameters: .init(
                            userId: 1,
                            id: 1,
                            title: "sample title",
                            body: "sample body"
                        ),
                        pathComponent: 1
                    )
                )
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
