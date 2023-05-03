@testable import EngineerMemo
import XCTest

final class SkillContentTypeTest: XCTestCase {
    func test_engineerCareer_titleの文字列がエンジニア歴であること() {
        // assert
        XCTAssertEqual(SkillContentType.engineerCareer.title, "エンジニア歴")
    }
}
