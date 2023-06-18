@testable import EngineerMemo
import XCTest

final class OptionalExtensionTest: XCTestCase {
    func test_isNil_値がnilの際にtrueを返すこと() {
        // arrange
        let test: String? = nil

        // assert
        XCTAssertTrue(test.isNil)
    }

    func test_isNil_値がある際にfalseを返すこと() {
        // arrange
        let test: String? = "nil"

        // assert
        XCTAssertFalse(test.isNil)
    }

    func test_isEmpty_配列がnilの際にtrueを返すこと() {
        // arrange
        let array: [String]? = nil

        // assert
        XCTAssertTrue(array.isEmpty)
    }

    func test_isEmpty_配列が空の際にtrueを返すこと() {
        // arrange
        let array: [String]? = []

        // assert
        XCTAssertTrue(array.isEmpty)
    }

    func test_isEmpty_配列に値がある際にfalseを返すこと() {
        // arrange
        let array: [String]? = ["a", "b", "c"]

        // assert
        XCTAssertFalse(array.isEmpty)
    }
}
