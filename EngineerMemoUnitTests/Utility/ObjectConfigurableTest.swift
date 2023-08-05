@testable import EngineerMemo
import XCTest

final class ObjectConfigurableTest: XCTestCase {
    func test_configure() {
        // arrange
        let button = UIButton()

        // act
        button.configure {
            $0.setTitle("button", for: .normal)
            $0.setTitleColor(.red, for: .normal)
        }

        // assert
        XCTAssertEqual(button.title(for: .normal), "button")
        XCTAssertEqual(button.titleColor(for: .normal), .red)
    }
}
