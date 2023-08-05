@testable import EngineerMemo
import XCTest

final class UIImageExtensionTest: XCTestCase {
    func test_resized() {
        // arrange
        let image = UIImage(systemName: "house")

        // act
        let resizedImage = image?.resized(
            size: .init(
                width: 100,
                height: 100
            )
        )

        // assert
        XCTAssertEqual(
            resizedImage?.size,
            .init(
                width: 100,
                height: 100
            )
        )
    }
}
