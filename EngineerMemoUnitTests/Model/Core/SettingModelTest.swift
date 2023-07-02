@testable import EngineerMemo
import XCTest

final class SettingModelTest: XCTestCase {
    private var model: SettingModel!

    override func setUp() {
        super.setUp()

        model = .init()
    }

    override func tearDown() {
        super.tearDown()

        model = nil

        resetUserDefaults()
    }

    func test_updateColorTheme_0_DataHolderのcolorThemeがsystemに変更されること() {
        // arrange
        let input = 0

        // act
        model.updateColorTheme(input)

        // assert
        XCTAssertEqual(
            DataHolder.colorTheme,
            .system
        )
    }

    func test_updateColorTheme_1_DataHolderのcolorThemeがlightに変更されること() {
        // arrange
        let input = 1

        // act
        model.updateColorTheme(input)

        // assert
        XCTAssertEqual(
            DataHolder.colorTheme,
            .light
        )
    }

    func test_updateColorTheme_2_DataHolderのcolorThemeがdarkに変更されること() {
        // arrange
        let input = 2

        // act
        model.updateColorTheme(input)

        // assert
        XCTAssertEqual(
            DataHolder.colorTheme,
            .dark
        )
    }

    func test_updateColorTheme_例外_DataHolderのcolorThemeがsystemに変更されること() {
        // arrange
        let input = 99

        // act
        model.updateColorTheme(input)

        // assert
        XCTAssertEqual(
            DataHolder.colorTheme,
            .system
        )
    }
}
