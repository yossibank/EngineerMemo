@testable import EngineerMemo
import XCTest

final class ArrayExtensionTest: XCTestCase {
    func test_safe_subscript_index内の値を参照した際にoptionalで値を取得できること() {
        // arrange
        let array = ["A", "B", "C", "D", "E"]

        // assert
        XCTAssertEqual(
            array[safe: 0],
            Optional("A")
        )
    }

    func test_safe_subscript_index外の値を参照した際にnilを取得できること() {
        // arrange
        let array = ["A", "B", "C", "D", "E"]

        // assert
        XCTAssertEqual(
            array[safe: 5],
            nil
        )
    }

    func test_unique_配列内の値を重複せずに取得できること() {
        // arrange
        let array = ["A", "B", "A", "D", "E", "C", "D", "E"]

        // assert
        XCTAssertEqual(
            array.unique,
            ["A", "B", "D", "E", "C"]
        )
    }
}
