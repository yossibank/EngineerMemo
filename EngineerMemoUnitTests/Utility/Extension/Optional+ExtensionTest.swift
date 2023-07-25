@testable import EngineerMemo
import XCTest

final class OptionalExtensionTest: XCTestCase {
    func test_isNil_値がnilの際にtrueを返すこと() {
        // arrange
        let test: String? = nil

        // act
        let value = test.isNil

        // assert
        XCTAssertTrue(value)
    }

    func test_isNil_値がある際にfalseを返すこと() {
        // arrange
        let test: String? = "nil"

        // act
        let value = test.isNil

        // assert
        XCTAssertFalse(value)
    }

    func test_isEmpty_配列がnilの際にtrueを返すこと() {
        // arrange
        let array: [String]? = nil

        // act
        let value = array.isEmpty

        // assert
        XCTAssertTrue(value)
    }

    func test_isEmpty_配列が空の際にtrueを返すこと() {
        // arrange
        let array: [String]? = []

        // act
        let value = array.isEmpty

        // assert
        XCTAssertTrue(value)
    }

    func test_isEmpty_配列に値がある際にfalseを返すこと() {
        // arrange
        let array: [String]? = ["a", "b", "c"]

        // act
        let value = array.isEmpty

        // assert
        XCTAssertFalse(value)
    }
}
