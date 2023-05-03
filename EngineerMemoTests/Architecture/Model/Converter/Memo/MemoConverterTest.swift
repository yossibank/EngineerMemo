@testable import EngineerMemo
import XCTest

final class MemoConverterTest: XCTestCase {
    private var converter: MemoConverter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    override func tearDown() {
        super.tearDown()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_MemoをMemoModelObjectに変換できること() {
        // arrange
        let input = MemoDataObjectBuilder()
            .category(.technical)
            .content("コンテンツ")
            .identifier("identifier")
            .title("タイトル")
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            MemoModelObjectBuilder()
                .category(.technical)
                .content("コンテンツ")
                .identifier("identifier")
                .title("タイトル")
                .build()
        )
    }

    func test_categoryがtodoの際にtodoに変換されること() {
        // arrange
        let input = MemoDataObjectBuilder()
            .category(.todo)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            MemoModelObjectBuilder()
                .category(.todo)
                .build()
        )
    }

    func test_categoryがtechnicalの際にtechnicalに変換されること() {
        // arrange
        let input = MemoDataObjectBuilder()
            .category(.technical)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            MemoModelObjectBuilder()
                .category(.technical)
                .build()
        )
    }

    func test_categoryがinterviewの際にinterviewに変換されること() {
        // arrange
        let input = MemoDataObjectBuilder()
            .category(.interview)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            MemoModelObjectBuilder()
                .category(.interview)
                .build()
        )
    }

    func test_categoryがeventの際にeventに変換されること() {
        // arrange
        let input = MemoDataObjectBuilder()
            .category(.event)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            MemoModelObjectBuilder()
                .category(.event)
                .build()
        )
    }

    func test_categoryがotherの際にotherに変換されること() {
        // arrange
        let input = MemoDataObjectBuilder()
            .category(.other)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            MemoModelObjectBuilder()
                .category(.other)
                .build()
        )
    }

    func test_titleがnilの際に未設定の文字列に変換されること() {
        // arrange
        let input = MemoDataObjectBuilder()
            .title(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            MemoModelObjectBuilder()
                .title(.noSetting)
                .build()
        )
    }

    func test_contentがnilの際に未設定の文字列に変換されること() {
        // arrange
        let input = MemoDataObjectBuilder()
            .content(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            MemoModelObjectBuilder()
                .content(.noSetting)
                .build()
        )
    }
}
