@testable import EngineerMemo
import XCTest

final class SkillConverterTest: XCTestCase {
    private var converter: SkillConverter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    override func tearDown() {
        super.tearDown()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_SkillをSkillModelObjectに変換できること() {
        // arrange
        let input = SkillDataObjectBuilder()
            .career(3)
            .identifier("identifier")
            .toeic(600)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            SKillModelObjectBuilder()
                .career(3)
                .identifier("identifier")
                .toeic(600)
                .build()
        )
    }
}
