import Combine
@testable import EngineerMemo
import XCTest

final class MemoModelTest: XCTestCase {
    private var memoConverter: MemoConverterInputMock!
    private var errorConverter: AppErrorConverterInputMock!
    private var model: MemoModel!
    private var cancellables: Set<AnyCancellable> = .init()

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

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_fetch_成功_情報を取得できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        memoConverter.convertHandler = {
            // assert
            XCTAssertEqual($0.category, .technical)
            XCTAssertEqual($0.content, "コンテンツ")
            XCTAssertEqual($0.createdAt, Calendar.date(year: 2000, month: 1, day: 1))
            XCTAssertEqual($0.identifier, "identifier")
            XCTAssertEqual($0.title, "タイトル")

            return MemoModelObjectBuilder()
                .category(.technical)
                .content($0.content!)
                .createdAt($0.createdAt!)
                .identifier($0.identifier)
                .title($0.title!)
                .build()
        }

        // act
        model.fetch {
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

        wait(for: [expectation], timeout: 0.1)
    }

    func test_find_成功_情報を取得できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        memoConverter.convertHandler = {
            // assert
            XCTAssertEqual($0.category, .technical)
            XCTAssertEqual($0.content, "コンテンツ")
            XCTAssertEqual($0.createdAt, Calendar.date(year: 2000, month: 1, day: 1))
            XCTAssertEqual($0.identifier, "identifier")
            XCTAssertEqual($0.title, "タイトル")

            return MemoModelObjectBuilder()
                .category(.technical)
                .content($0.content!)
                .createdAt($0.createdAt!)
                .identifier($0.identifier)
                .title($0.title!)
                .build()
        }

        // act
        model.find(identifier: "identifier") {
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

        wait(for: [expectation], timeout: 0.1)
    }

    func test_create_情報を作成できること() {
        // act
        let expectation = XCTestExpectation(description: #function)

        model.create(
            modelObject: MemoModelObjectBuilder()
                .category(.technical)
                .content("コンテンツ")
                .createdAt(Calendar.date(year: 2000, month: 1, day: 1)!)
                .title("タイトル")
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let memo = self.storage.allObjects.first!

            // assert
            XCTAssertEqual(memo.category, .technical)
            XCTAssertEqual(memo.content, "コンテンツ")
            XCTAssertEqual(memo.createdAt, Calendar.date(year: 2000, month: 1, day: 1))
            XCTAssertEqual(memo.title, "タイトル")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.3)
    }

    func test_update_情報を更新できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let memo = self.storage.allObjects.first!

            // assert
            XCTAssertEqual(memo.category, .interview)
            XCTAssertEqual(memo.content, "コンテンツ更新後")
            XCTAssertEqual(memo.createdAt, Calendar.date(year: 2000, month: 1, day: 1))
            XCTAssertEqual(memo.title, "タイトル更新後")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.3)
    }

    func test_delete_情報を削除できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        // act
        model.delete(
            modelObject: MemoModelObjectBuilder()
                .identifier("identifier")
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let allMemo = self.storage.allObjects

            // assert
            XCTAssertTrue(allMemo.isEmpty)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
}

private extension MemoModelTest {
    func dataInsert() {
        storage.create().sink {
            $0.category = .technical
            $0.content = "コンテンツ"
            $0.createdAt = Calendar.date(year: 2000, month: 1, day: 1)
            $0.identifier = "identifier"
            $0.title = "タイトル"
        }
        .store(in: &cancellables)
    }
}
