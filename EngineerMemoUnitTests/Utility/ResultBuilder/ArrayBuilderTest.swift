@testable import EngineerMemo
import XCTest

final class ArrayBuilderTest: XCTestCase {
    func test_配列生成ができること_分岐なし_ループなし() {
        // arrange
        @ArrayBuilder<Int>
        func build() -> [Int] {
            1
            2
            3
        }

        // act
        let value = build()

        // assert
        XCTAssertEqual(
            value,
            [1, 2, 3]
        )
    }

    func test_配列生成ができること_分岐あり_ループなし() {
        // arrange
        @ArrayBuilder<Int>
        func build() -> [Int] {
            1
            2
            3

            if true {
                4
            }

            if "false" == "False" {
                5
                6
            } else {
                7
                8
                9
            }
        }

        // act
        let value = build()

        // assert
        XCTAssertEqual(
            value,
            [1, 2, 3, 4, 7, 8, 9]
        )
    }

    func test_配列生成ができること_分岐なし_ループあり() {
        // arrange
        @ArrayBuilder<Int>
        func build() -> [Int] {
            1
            2
            3

            for i in 4 ... 6 {
                i
            }

            7
            8
            9
        }

        // act
        let value = build()

        // assert
        XCTAssertEqual(
            value,
            [1, 2, 3, 4, 5, 6, 7, 8, 9]
        )
    }

    func test_配列生成ができること_分岐あり_ループあり() {
        // arrange
        @ArrayBuilder<Int>
        func build() -> [Int] {
            1
            2
            3

            for i in 4 ... 6 {
                i
            }

            if true {
                7
            }

            if "false" == "False" {
                8
                9
            } else {
                10
            }
        }

        // act
        let value = build()

        // assert
        XCTAssertEqual(
            value,
            [1, 2, 3, 4, 5, 6, 7, 10]
        )
    }
}
