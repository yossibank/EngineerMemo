@testable import EngineerMemo
import XCTest

final class SkillContentTypeTest: XCTestCase {
    func test_career_titleの文字列がエンジニア歴であること() {
        // assert
        XCTAssertEqual(SkillContentType.career.title, "エンジニア歴")
    }
}
