@testable import EngineerMemo
import XCTest

final class ProjectConverterTest: XCTestCase {
    private var converter: ProjectConverter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    override func tearDown() {
        super.tearDown()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_ProjectをProjectModelObjectに変換できること() {
        // arrange
        let input = ProjectDataObjectBuilder()
            .content("content")
            .identifier("identifier")
            .title("title")
            .profile(
                ProfileDataObjectBuilder()
                    .build()
            )
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProjectModelObjectBuilder()
                .content("content")
                .identifier("identifier")
                .title("title")
                .build()
        )
    }
}
