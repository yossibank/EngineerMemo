@testable import EngineerMemo
import XCTest

final class UIEdgeInsetsExtensionTest: XCTestCase {
    func test_init_direction_top() {
        // arrange
        let inset = UIEdgeInsets(
            .all,
            10
        )

        // act
        let value = inset.top

        // assert
        XCTAssertEqual(
            value,
            10
        )
    }

    func test_init_direction_left() {
        // arrange
        let inset = UIEdgeInsets(
            .left,
            10
        )

        // act
        let value = inset.left

        // assert
        XCTAssertEqual(
            value,
            10
        )
    }

    func test_init_direction_bottom() {
        // arrange
        let inset = UIEdgeInsets(
            .bottom,
            10
        )

        // act
        let value = inset.bottom

        // assert
        XCTAssertEqual(
            value,
            10
        )
    }

    func test_init_direction_right() {
        // arrange
        let inset = UIEdgeInsets(
            .right,
            10
        )

        // act
        let value = inset.right

        // assert
        XCTAssertEqual(
            value,
            10
        )
    }

    func test_init_direction_horizontal() {
        // arrange
        let inset = UIEdgeInsets(
            .horizontal,
            10
        )

        let left = inset.left
        let right = inset.right

        // assert
        XCTAssertEqual(left, 10)
        XCTAssertEqual(right, 10)
    }

    func test_init_direction_vertical() {
        // arrange
        let inset = UIEdgeInsets(
            .vertical,
            10
        )

        // act
        let top = inset.top
        let bottom = inset.bottom

        // assert
        XCTAssertEqual(top, 10)
        XCTAssertEqual(bottom, 10)
    }

    func test_init_direction_all() {
        // arrange
        let inset = UIEdgeInsets(
            .all,
            10
        )

        // act
        let top = inset.top
        let left = inset.left
        let bottom = inset.bottom
        let right = inset.right

        // assert
        XCTAssertEqual(top, 10)
        XCTAssertEqual(left, 10)
        XCTAssertEqual(bottom, 10)
        XCTAssertEqual(right, 10)
    }

    func test_init_directions() {
        // arrange
        let inset1 = UIEdgeInsets(
            [.top, .left],
            10
        )

        // act
        let value1Top = inset1.top
        let value1Left = inset1.left

        // assert
        XCTAssertEqual(value1Top, 10)
        XCTAssertEqual(value1Left, 10)

        // arrange
        let inset2 = UIEdgeInsets(
            [.top, .right],
            10
        )

        // act
        let value2Top = inset2.top
        let value2Right = inset2.right

        // assert
        XCTAssertEqual(value2Top, 10)
        XCTAssertEqual(value2Right, 10)

        // arrange
        let inset3 = UIEdgeInsets(
            [.bottom, .right],
            10
        )

        // act
        let value3Bottom = inset3.bottom
        let value3Right = inset3.right

        // assert
        XCTAssertEqual(value3Bottom, 10)
        XCTAssertEqual(value3Right, 10)

        // arrange
        let inset4 = UIEdgeInsets(
            [.top, .horizontal],
            10
        )

        // act
        let value4Top = inset4.top
        let value4Left = inset4.left
        let value4Right = inset4.right

        // assert
        XCTAssertEqual(value4Top, 10)
        XCTAssertEqual(value4Left, 10)
        XCTAssertEqual(value4Right, 10)
    }
}
