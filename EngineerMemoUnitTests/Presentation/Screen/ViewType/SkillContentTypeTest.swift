@testable import EngineerMemo
import XCTest

final class SkillContentTypeTest: XCTestCase {
    func test_engineerCareer_titleの文字列がエンジニア歴であること() {
        // assert
        XCTAssertEqual(
            SkillContentType.engineerCareer.title,
            "エンジニア歴"
        )
    }

    func test_language_titleの文字列が得意言語であること() {
        // assert
        XCTAssertEqual(
            SkillContentType.language.title,
            "得意言語"
        )
    }

    func test_toeic_titleの文字列がTOEICであること() {
        // assert
        XCTAssertEqual(
            SkillContentType.toeic.title,
            "TOEIC"
        )
    }
}
