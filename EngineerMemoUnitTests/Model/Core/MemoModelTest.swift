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

    func test_fetch_メモ情報を取得できること() throws {
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

        let publisher = model.fetch().collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!

        // assert
        // assert
        XCTAssertEqual(
            output,
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
    }

    func test_find_メモ情報を取得できること() throws {
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

        let publisher = model.find(identifier: "identifier").collect(1).first()
        let output = try awaitOutputPublisher(publisher).first!

        // assert
        XCTAssertEqual(
            output,
            MemoModelObjectBuilder()
                .category(.technical)
                .content("コンテンツ")
                .createdAt(Calendar.date(year: 2000, month: 1, day: 1)!)
                .identifier("identifier")
                .title("タイトル")
                .build()
        )
    }

    func test_create_メモ情報を作成できること() throws {
        // act
        let publisher = model.create(
            MemoModelObjectBuilder()
                .category(.technical)
                .content("コンテンツ")
                .createdAt(Calendar.date(year: 2000, month: 1, day: 1)!)
                .title("タイトル")
                .build()
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

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

    func test_update_メモ情報を更新できること() throws {
        // arrange
        dataInsert()

        // act
        let publisher = model.update(
            MemoModelObjectBuilder()
                .category(.interview)
                .content("コンテンツ更新後")
                .createdAt(Calendar.date(year: 2000, month: 1, day: 1)!)
                .identifier("identifier")
                .title("タイトル更新後")
                .build()
        )
        .collect(1)
        .first()

        _ = try awaitOutputPublisher(publisher)

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
            MemoModelObjectBuilder()
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
