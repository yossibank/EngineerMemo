import Combine
@testable import EngineerMemo
import XCTest

final class WidgetModelTest: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        super.tearDown()

        cancellables.removeAll()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_memoList_カテゴリーwidgetのメモ情報を取得できること() {
        // arrange
        dataInsert(category: .event, prefix: 1)
        dataInsert(category: .interview, prefix: 2)
        dataInsert(category: .widget, prefix: 3)
        dataInsert(category: .tax, prefix: 4)
        dataInsert(category: .widget, prefix: 5)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                // act
                let memoList = WidgetModel.memoList

                // assert
                XCTAssertEqual(memoList.count, 2)
                XCTAssertEqual(
                    memoList,
                    [
                        MemoModelObjectBuilder()
                            .category(.widget)
                            .identifier("identifier5")
                            .title("タイトル:5")
                            .content("コンテンツ:5")
                            .createdAt(Calendar.date(year: 2000, month: 1, day: 5)!)
                            .build(),
                        MemoModelObjectBuilder()
                            .category(.widget)
                            .identifier("identifier3")
                            .title("タイトル:3")
                            .content("コンテンツ:3")
                            .createdAt(Calendar.date(year: 2000, month: 1, day: 3)!)
                            .build()
                    ]
                )

                expectation.fulfill()
            }
        }
    }

    func test_memoList_値未設定_カテゴリーwidgetのメモ情報を取得できること() {
        // arrange
        emptyDataInsert(category: .event, prefix: 1)
        emptyDataInsert(category: .interview, prefix: 2)
        emptyDataInsert(category: .widget, prefix: 3)
        emptyDataInsert(category: .tax, prefix: 4)
        emptyDataInsert(category: .widget, prefix: 5)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                // act
                let memoList = WidgetModel.memoList

                // assert
                XCTAssertEqual(memoList.count, 2)
                XCTAssertEqual(
                    memoList,
                    [
                        MemoModelObjectBuilder()
                            .category(.widget)
                            .identifier("identifier5")
                            .title("未設定")
                            .content("未設定")
                            .createdAt(Calendar.date(year: 2000, month: 1, day: 5)!)
                            .build(),
                        MemoModelObjectBuilder()
                            .category(.widget)
                            .identifier("identifier3")
                            .title("未設定")
                            .content("未設定")
                            .createdAt(Calendar.date(year: 2000, month: 1, day: 3)!)
                            .build()
                    ]
                )

                expectation.fulfill()
            }
        }
    }
}

private extension WidgetModelTest {
    func dataInsert(
        category: Memo.Category,
        prefix: Int
    ) {
        CoreDataStorage<Memo>().create().sink {
            $0.object.category = category
            $0.object.content = "コンテンツ:\(prefix.description)"
            $0.object.createdAt = Calendar.date(year: 2000, month: 1, day: prefix)
            $0.object.identifier = "identifier\(prefix.description)"
            $0.object.title = "タイトル:\(prefix.description)"
            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }

    func emptyDataInsert(
        category: Memo.Category,
        prefix: Int
    ) {
        CoreDataStorage<Memo>().create().sink {
            $0.object.category = category
            $0.object.content = nil
            $0.object.createdAt = Calendar.date(year: 2000, month: 1, day: prefix)
            $0.object.identifier = "identifier\(prefix.description)"
            $0.object.title = nil
            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }
}
