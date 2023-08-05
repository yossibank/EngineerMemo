@testable import EngineerMemo
import XCTest

final class ViewStyleTest: XCTestCase {
    func test_apply() {
        // arrange
        let label = UILabel()
        let labelStyle = ViewStyle<UILabel> {
            $0.text = "label"
            $0.backgroundColor = .red
        }

        // act
        label.apply(labelStyle)

        // assert
        XCTAssertEqual(label.text, "label")
        XCTAssertEqual(label.backgroundColor, .red)
    }
}
