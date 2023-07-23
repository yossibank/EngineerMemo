import Combine
@testable import EngineerMemo
import XCTest

final class WidgetModelTest: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        super.tearDown()

        cancellables.removeAll()
    }

    func test_memoList_カテゴリーwidgetのメモ情報を取得できること() {
        // arrange
        dataInsert(category: .event)
        dataInsert(category: .interview)
        dataInsert(category: .widget)
        dataInsert(category: .tax)

        wait(timeout: 0.5) { expectation in
            Task {
                try await Task.sleep(seconds: 0.3)

                // act
                let memoList = WidgetModel.memoList
                let memo = memoList.first!

                // assert
                XCTAssertEqual(memoList.count, 1)
                XCTAssertEqual(memo.title, "タイトル:6")
                XCTAssertEqual(memo.content, "コンテンツ:6")
                XCTAssertEqual(memo.identifier, "identifier6")

                expectation.fulfill()
            }
        }
    }
}

private extension WidgetModelTest {
    func dataInsert(category: Memo.Category) {
        CoreDataStorage<Memo>().create().sink {
            $0.object.category = category
            $0.object.content = "コンテンツ:\(category.rawValue)"
            $0.object.createdAt = Calendar.date(year: 2000, month: 1, day: 1)
            $0.object.identifier = "identifier\(category.rawValue)"
            $0.object.title = "タイトル:\(category.rawValue)"
            $0.context.saveIfNeeded()
        }
        .store(in: &cancellables)
    }
}
