@testable import EngineerMemo
import XCTest

final class ___FILEBASENAME___: XCTestCase {
    private var mapper: 対象Mapper!

    override func setUp() {
        super.setUp()

        mapper = .init()
    }

    func test_対象ModelObjectを対象PresentationObjectに変換できること() {
        // arrange
        let input = 対象ModelObjectBuilder()
            .プロパティ(値)
            .build()

        // act
        let actual = mapper.map(input)

        // assert
        XCTAssertEqual(
            actual,
            対象PresentationObjectBuilder()
                .プロパティ(値)
                .build()
        )
    }

    // 変換時に型変更が生じる際に各自テストケースを追加する
    // ex) func test_imageUrlがnilの際ににshouldShowSettingがtrueに変換されること()
}