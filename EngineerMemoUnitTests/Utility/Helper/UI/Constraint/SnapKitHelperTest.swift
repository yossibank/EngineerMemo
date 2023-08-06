@testable import EngineerMemo
import XCTest

final class SnapkitHelperTest: XCTestCase {
    func test_viewLayoutable_addSubview() {
        // arrange
        let parentView = UIView()
        parentView.backgroundColor = .red

        let childView = UIView()
        childView.backgroundColor = .blue

        // act
        parentView.addSubview(childView) {
            $0.width.equalTo(100)
            $0.height.equalTo(200)
        }

        // assert
        XCTAssertTrue(parentView.subviews.contains(childView))
        XCTAssertEqual(childView.constraints[0].constant, 100)
        XCTAssertEqual(childView.constraints[1].constant, 200)
    }

    func test_viewLayoutable_addConstraint() {
        // arrange
        let view = UIView()

        // act
        view.addConstraint {
            $0.width.equalTo(100)
            $0.height.equalTo(200)
        }

        // assert
        XCTAssertEqual(view.constraints.count, 2)
        XCTAssertEqual(view.constraints[0].constant, 100)
        XCTAssertEqual(view.constraints[1].constant, 200)
    }
}
