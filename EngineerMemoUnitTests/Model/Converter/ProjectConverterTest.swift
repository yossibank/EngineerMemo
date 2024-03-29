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

        converter = nil

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_ProjectをProjectModelObjectに変換できること() {
        // arrange
        let input = [
            ProjectDataObjectBuilder()
                .content("content")
                .database("CoreData")
                .endDate(Calendar.date(year: 2021, month: 12, day: 1))
                .identifier("identifier")
                .language("Swift5.8")
                .processes([1, 3, 5])
                .role("プログラマー")
                .serverOS("Ubuntu")
                .startDate(Calendar.date(year: 2020, month: 1, day: 1))
                .title("title")
                .tools(["Firebase", "MagicPod"])
                .build()
        ]

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            [
                ProjectModelObjectBuilder()
                    .title("title")
                    .role("プログラマー")
                    .processes([.functionalDesign, .implementation, .systemTesting])
                    .language("Swift5.8")
                    .database("CoreData")
                    .serverOS("Ubuntu")
                    .tools(["Firebase", "MagicPod"])
                    .content("content")
                    .startDate(Calendar.date(year: 2020, month: 1, day: 1))
                    .endDate(Calendar.date(year: 2021, month: 12, day: 1))
                    .identifier("identifier")
                    .build()
            ]
        )
    }
}
