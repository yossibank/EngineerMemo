@testable import EngineerResume
import XCTest

final class ProfileConverterTest: XCTestCase {
    private var converter: ProfileConverter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    override func tearDown() {
        super.tearDown()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_ProfileをProfileModelObjectに変換できること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .identifier("identifier")
            .name("テスト")
            .age(20)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .name("テスト")
                .age(20)
                .build()
        )
    }

    func test_nameがnilの際に空文字に変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .identifier("identifier")
            .name(nil)
            .age(10)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .name("")
                .age(10)
                .build()
        )
    }

    func test_ageがnilの際に不正値に変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .identifier("identifier")
            .name("テスト")
            .age(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .identifier("identifier")
                .name("テスト")
                .age(-1)
                .build()
        )
    }
}
