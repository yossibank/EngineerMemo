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

        converter = nil

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_SkillをSkillModelObjectに変換できること() {
        // arrange
        let input = SkillDataObjectBuilder()
            .engineerCareer(3)
            .identifier("identifier")
            .language("Swift")
            .languageCareer(2)
            .toeic(600)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            SKillModelObjectBuilder()
                .engineerCareer(3)
                .identifier("identifier")
                .language("Swift")
                .languageCareer(2)
                .toeic(600)
                .build()
        )
    }
}
