@testable import EngineerMemo
import XCTest

final class AppURLSchemeTest: XCTestCase {
    func test_schemeURL_memoDetail_メモ詳細用のURLを生成できること() {
        // arrange
        let scheme = AppURLScheme.memoDetail
        let queryItem = AppURLScheme.QueryItem.identifier("test123")

        // act
        let schemeURL = scheme.schemeURL(queryItems: [queryItem])

        // assert
        XCTAssertEqual(
            schemeURL,
            .init(string: "engineermemo://memo-detail?identifier=test123")
        )
    }

    func test_schemeURL_memoCreate_メモ作成用のURLを生成できること() {
        // arrange
        let scheme = AppURLScheme.memoCreate

        // act
        let schemeURL = scheme.schemeURL()

        // assert
        XCTAssertEqual(
            schemeURL,
            .init(string: "engineermemo://memo-create?")
        )
    }
}
