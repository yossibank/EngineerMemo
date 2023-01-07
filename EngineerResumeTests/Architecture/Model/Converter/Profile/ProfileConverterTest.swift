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
}
