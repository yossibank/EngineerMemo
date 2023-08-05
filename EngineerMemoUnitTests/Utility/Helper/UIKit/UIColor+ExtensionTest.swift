import XCTest
@testable import EngineerMemo

final class UIColorExtensionTest: XCTestCase {
    func test_dynamicColor() {
        // arrange
        let color = UIColor.dynamicColor(light: .white, dark: .black)
        let view = UIView()
        view.backgroundColor = color

        // act
        UITraitCollection.current = .init(userInterfaceStyle: .light)

        // assert
        XCTAssertEqual(
            view.backgroundColor?.cgColor,
            UIColor.white.cgColor
        )

        // act
        UITraitCollection.current = .init(userInterfaceStyle: .dark)

        // assert
        XCTAssertEqual(
            view.backgroundColor?.cgColor,
            UIColor.black.cgColor
        )
    }
}
