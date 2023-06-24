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

        // act
        let nilObject = array[safe: 5]

        // assert
        XCTAssertNil(nilObject)
    }

    func test_unique_配列内の値を重複せずに取得できること() {
        // arrange
        let array = ["A", "B", "A", "D", "E", "C", "D", "E"]

        // act
        let uniqueArray = array.unique

        // assert
        XCTAssertEqual(
            uniqueArray,
            ["A", "B", "D", "E", "C"]
        )
    }

    func test_replace_配列内の要素を引数の値で変換できること() {
        // arrange
        var array = ["A", "B", "C"]

        // act
        array.replace(
            before: "A",
            after: "ABC"
        )

        // assert
        XCTAssertEqual(
            array,
            ["ABC", "B", "C"]
        )
    }
}
