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
                .endDate(Calendar.date(year: 2021, month: 12, day: 1))
                .identifier("identifier")
                .role("プログラマー")
                .startDate(Calendar.date(year: 2020, month: 1, day: 1))
                .title("title")
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
                    .content("content")
                    .startDate(Calendar.date(year: 2020, month: 1, day: 1))
                    .endDate(Calendar.date(year: 2021, month: 12, day: 1))
                    .identifier("identifier")
                    .build()
            ]
        )
    }
}
