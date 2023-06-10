@testable import EngineerMemo
import XCTest

final class MemoModelObjectTest: XCTestCase {
    func test_category_todo_valueの文字列がTODOであること() {
        // assert
        XCTAssertEqual(
            MemoModelObject.Category.todo.value,
            "TODO"
        )
    }

    func test_category_technincal_valueの文字列が技術であること() {
        // assert
        XCTAssertEqual(
            MemoModelObject.Category.technical.value,
            "技術"
        )
    }

    func test_category_interview_valueの文字列が面接であること() {
        // assert
        XCTAssertEqual(
            MemoModelObject.Category.interview.value,
            "面接"
        )
    }

    func test_category_event_valueの文字列がイベントであること() {
        // assert
        XCTAssertEqual(
            MemoModelObject.Category.event.value,
            "イベント"
        )
    }

    func test_category_tax_valueの文字列が税金であること() {
        // assert
        XCTAssertEqual(
            MemoModelObject.Category.tax.value,
            "税金"
        )
    }

    func test_category_other_valueの文字列がその他であること() {
        // assert
        XCTAssertEqual(
            MemoModelObject.Category.other.value,
            "その他"
        )
    }
}
