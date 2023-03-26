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

    func test_get_成功_情報を取得できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        memoConverter.convertHandler = {
            // assert
            XCTAssertEqual($0.content, "コンテンツ")
            XCTAssertEqual($0.identifier, "identifier")
            XCTAssertEqual($0.title, "タイトル")

            return MemoModelObjectBuilder()
                .content($0.content!)
                .identifier($0.identifier)
                .title($0.title!)
                .build()
        }

        // act
        model.get {
            switch $0 {
            case let .success(modelObject):
                // assert
                XCTAssertEqual(
                    modelObject,
                    MemoModelObjectBuilder()
                        .content("コンテンツ")
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

    func test_gets_成功_情報を取得できること() {
        // arrange
        dataInsert()

        let expectation = XCTestExpectation(description: #function)

        memoConverter.convertHandler = {
            // assert
            XCTAssertEqual($0.content, "コンテンツ")
            XCTAssertEqual($0.identifier, "identifier")
            XCTAssertEqual($0.title, "タイトル")

            return MemoModelObjectBuilder()
                .content($0.content!)
                .identifier($0.identifier)
                .title($0.title!)
                .build()
        }

        // act
        model.gets {
            switch $0 {
            case let .success(modelObject):
                // assert
                XCTAssertEqual(
                    modelObject,
                    [
                        MemoModelObjectBuilder()
                            .content("コンテンツ")
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

    func test_create_情報を作成できること() {
        // act
        let expectation = XCTestExpectation(description: #function)

        model.create(
            modelObject: MemoModelObjectBuilder()
                .content("コンテンツ")
                .title("タイトル")
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let memo = self.storage.allObjects.first!

            // assert
            XCTAssertEqual(memo.content, "コンテンツ")
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
                .content("コンテンツ更新後")
                .identifier("identifier")
                .title("タイトル更新後")
                .build()
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let memo = self.storage.allObjects.first!

            // assert
            XCTAssertEqual(memo.content, "コンテンツ更新後")
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
        storage.create()
            .sink {
                $0.content = "コンテンツ"
                $0.identifier = "identifier"
                $0.title = "タイトル"
            }
            .store(in: &cancellables)
    }
}
