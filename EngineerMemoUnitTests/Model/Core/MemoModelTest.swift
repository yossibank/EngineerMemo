import Combine
@testable import EngineerMemo
import XCTest

final class MemoModelTest: XCTestCase {
    private var memoConverter: MemoConverterInputMock!
    private var errorConverter: AppErrorConverterInputMock!
    private var model: MemoModel!
    private var cancellables = Set<AnyCancellable>()

    private let storage = CoreDataStorage<Memo>()

    override func setUp() {
        super.setUp()

        memoConverter = .init()
        errorConverter = .init()
        model = .init(
            memoConverter: memoConverter,
            errorConverter: errorConverter
        )
    }

    override func tearDown() {
        super.tearDown()

        memoConverter = nil
        errorConverter = nil
        model = nil
        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_fetch_成功_情報を取得できること() {
        // arrange
        dataInsert()

        memoConverter.convertHandler = {
            // assert
            XCTAssertEqual(
                $0.category,
                .technical
            )

            XCTAssertEqual(
                $0.content,
                "コンテンツ"
            )

            XCTAssertEqual(
                $0.createdAt,
                Calendar.date(year: 2000, month: 1, day: 1)
            )

            XCTAssertEqual(
                $0.identifier,
                "identifier"
            )

            XCTAssertEqual(
                $0.title,
                "タイトル"
            )

            return MemoModelObjectBuilder()
                .category(.technical)
                .content($0.content!)
                .createdAt($0.createdAt!)
                .identifier($0.identifier)
                .title($0.title!)
                .build()
        }

        wait { expectation in
            // act
            self.model.fetch {
                switch $0 {
                case let .success(modelObjects):
                    guard !modelObjects.isEmpty else {
                        return
                    }

                    // assert
                    XCTAssertEqual(
                        modelObjects,
                        [
                            MemoModelObjectBuilder()
                                .category(.technical)
                                .content("コンテンツ")
                                .createdAt(Calendar.date(year: 2000, month: 1, day: 1)!)
                                .identifier("identifier")
                                .title("タイトル")
                                .build()
                        ]
                    )

                case let .failure(appError):
                    XCTFail(appError.localizedDescription)
                }

                expectation.fulfill()
            }
        }
    }

    func test_find_成功_情報を取得できること() {
        // arrange
        dataInsert()

        memoConverter.convertHandler = {
            // assert
            XCTAssertEqual(
                $0.category,
                .technical
            )

            XCTAssertEqual(
                $0.content,
                "コンテンツ"
            )

            XCTAssertEqual(
                $0.createdAt,
                Calendar.date(year: 2000, month: 1, day: 1)
            )

            XCTAssertEqual(
                $0.identifier,
                "identifier"
            )

            XCTAssertEqual(
                $0.title,
                "タイトル"
            )

            return MemoModelObjectBuilder()
                .category(.technical)
                .content($0.content!)
                .createdAt($0.createdAt!)
                .identifier($0.identifier)
                .title($0.title!)
                .build()
        }

        wait { expectation in
            // act
            self.model.find(identifier: "identifier") {
                switch $0 {
                case let .success(modelObject):
                    // assert
                    XCTAssertEqual(
                        modelObject,
                        MemoModelObjectBuilder()
                            .category(.technical)
                            .content("コンテンツ")
                            .createdAt(Calendar.date(year: 2000, month: 1, day: 1)!)
                            .identifier("identifier")
                            .title("タイトル")
                            .build()
                    )

                case let .failure(appError):
                    XCTFail(appError.localizedDescription)
                }

                expectation.fulfill()
            }
        }
    }

    func test_create_情報を作成できること() {
        // act
        model.create(
            modelObject: MemoModelObjectBuilder()
                .category(.technical)
                .content("コンテンツ")
                .createdAt(Calendar.date(year: 2000, month: 1, day: 1)!)
                .title("タイトル")
                .build()
        )

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let memo = self.storage.allObjects.first!

                // assert
                XCTAssertEqual(
                    memo.category,
                    .technical
                )

                XCTAssertEqual(
                    memo.content,
                    "コンテンツ"
                )

                XCTAssertEqual(
                    memo.createdAt,
                    Calendar.date(year: 2000, month: 1, day: 1)
                )

                XCTAssertEqual(
                    memo.title,
                    "タイトル"
                )

                expectation.fulfill()
            }
        }
    }

    func test_update_情報を更新できること() {
        // arrange
        dataInsert()

        // act
        model.update(
            modelObject: MemoModelObjectBuilder()
                .category(.interview)
                .content("コンテンツ更新後")
                .createdAt(Calendar.date(year: 2000, month: 1, day: 1)!)
                .identifier("identifier")
                .title("タイトル更新後")
                .build()
        )

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let memo = self.storage.allObjects.first!

                // assert
                XCTAssertEqual(
                    memo.category,
                    .interview
                )

                XCTAssertEqual(
                    memo.content,
                    "コンテンツ更新後"
                )

                XCTAssertEqual(
                    memo.createdAt,
                    Calendar.date(year: 2000, month: 1, day: 1)
                )

                XCTAssertEqual(
                    memo.title,
                    "タイトル更新後"
                )

                expectation.fulfill()
            }
        }
    }

    func test_delete_情報を削除できること() {
        // arrange
        dataInsert()

        // act
        model.delete(
            modelObject: MemoModelObjectBuilder()
                .identifier("identifier")
                .build()
        )

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                let allMemo = self.storage.allObjects

                // assert
                XCTAssertTrue(allMemo.isEmpty)

                expectation.fulfill()
            }
        }
    }
}

private extension MemoModelTest {
    func dataInsert() {
        storage.create().sink {
            $0.object.category = .technical
            $0.object.content = "コンテンツ"
            $0.object.createdAt = Calendar.date(year: 2000, month: 1, day: 1)
            $0.object.identifier = "identifier"
            $0.object.title = "タイトル"
            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }
}
