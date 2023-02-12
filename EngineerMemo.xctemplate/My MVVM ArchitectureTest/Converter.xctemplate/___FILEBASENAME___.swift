@testable import EngineerMemo
import XCTest

final class ___FILEBASENAME___: XCTestCase {
    private var converter: 対象Converter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    override func tearDown() {
        super.tearDown()

        // CoreData操作必要な場合はデータリセット
        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_対象DataObjectを対象ModelObjectに変換できること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .プロパティ(値)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .プロパティ(値)
                .build()
        )
    }

    // 変換時に型変更が生じる際に各自テストケースを追加する
    // ex) func test_addressがnilの際に未設定の文字列に変換されること()
    // ex) func test_genderがwomanの際にwomanに変換されること()
}
