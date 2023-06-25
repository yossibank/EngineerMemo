@testable import EngineerMemo
import XCTest

final class ProfileContentTypeTest: XCTestCase {
    func test_name_titleの文字列が名前であること() {
        // assert
        XCTAssertEqual(
            ProfileBasicContentType.name.title,
            "名前"
        )
    }

    func test_age_titleの文字列が年齢であること() {
        // assert
        XCTAssertEqual(
            ProfileBasicContentType.age.title,
            "年齢"
        )
    }

    func test_gender_titleの文字列が性別であること() {
        // assert
        XCTAssertEqual(
            ProfileBasicContentType.gender.title,
            "性別"
        )
    }

    func test_email_titleの文字列がメールアドレスであること() {
        // assert
        XCTAssertEqual(
            ProfileBasicContentType.email.title,
            "メールアドレス"
        )
    }

    func test_phoneNumber_titleの文字列が携帯番号であること() {
        // assert
        XCTAssertEqual(
            ProfileBasicContentType.phoneNumber.title,
            "電話番号"
        )
    }

    func test_address_titleの文字列が住所であること() {
        // assert
        XCTAssertEqual(
            ProfileBasicContentType.address.title,
            "住所"
        )
    }

    func test_station_titleの文字列が最寄駅であること() {
        // assert
        XCTAssertEqual(
            ProfileBasicContentType.station.title,
            "最寄駅"
        )
    }
}
