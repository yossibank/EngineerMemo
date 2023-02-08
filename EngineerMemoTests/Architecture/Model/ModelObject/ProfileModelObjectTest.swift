@testable import EngineerMemo
import XCTest

final class ProfileModelObjectTest: XCTestCase {
    func test_gender_man_valueの文字列が男性であること() {
        // assert
        XCTAssertEqual(ProfileModelObject.Gender.man.value, "男性")
    }

    func test_gender_woman_valueの文字列が女性であること() {
        // assert
        XCTAssertEqual(ProfileModelObject.Gender.woman.value, "女性")
    }

    func test_gender_other_valueの文字列がその他であること() {
        // assert
        XCTAssertEqual(ProfileModelObject.Gender.other.value, "その他")
    }

    func test_gender_none_valueの文字列が未設定であること() {
        // assert
        XCTAssertEqual(ProfileModelObject.Gender.none.value, "未設定")
    }
}
