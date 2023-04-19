@testable import EngineerMemo
import XCTest

final class MemoConverterTest: XCTestCase {
    private var converter: MemoConverter!

    override func setUp() {
        super.setUp()

        converter = .init()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    override func tearDown() {
        super.tearDown()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_MemoをMemoModelObjectに変換できること() {
        // arrange
        let input = MemoDataObjectBuilder()
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
                .content("コンテンツ")
                .identifier("identifier")
                .title("タイトル")
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
