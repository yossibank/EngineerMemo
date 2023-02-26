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
}
