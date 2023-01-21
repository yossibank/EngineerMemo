@testable import EngineerMemo
import XCTest

final class ProfileConverterTest: XCTestCase {
    private var converter: ProfileConverter!

    override func setUp() {
        super.setUp()

        converter = .init()
    }

    override func tearDown() {
        super.tearDown()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_ProfileをProfileModelObjectに変換できること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .address("テスト県テスト市テスト1-1-1")
            .age(20)
            .email("test@test.com")
            .gender(.man)
            .identifier("identifier")
            .name("テスト")
            .phoneNumber("08011112222")
            .station("鶴橋駅")
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .address("テスト県テスト市テスト1-1-1")
                .age(20)
                .email("test@test.com")
                .gender(.man)
                .identifier("identifier")
                .name("テスト")
                .phoneNumber("08011112222")
                .station("鶴橋駅")
                .build()
        )
    }

    func test_addressがnilの際に未設定の文字列に変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .address(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .address(.noSetting)
                .build()
        )
    }

    func test_ageがnilの際に不正値に変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .age(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .age(-1)
                .build()
        )
    }

    func test_emailがnilの際に未設定の文字列に変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .email(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .email(.noSetting)
                .build()
        )
    }

    func test_genderがmanの際にmanに変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .gender(.man)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .gender(.man)
                .build()
        )
    }

    func test_genderがwomanの際にwomanに変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .gender(.woman)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .gender(.woman)
                .build()
        )
    }

    func test_genderがotherの際にotherに変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .gender(.other)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .gender(.other)
                .build()
        )
    }

    func test_genderがnilの際にnilに変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .gender(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .gender(nil)
                .build()
        )
    }

    func test_nameがnilの際に未設定の文字列に変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .name(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .name(.noSetting)
                .build()
        )
    }

    func test_phoneNumberがnilの際に未設定の文字列に変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .phoneNumber(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .phoneNumber(.noSetting)
                .build()
        )
    }

    func test_stationがnilの際に未設定の文字列に変換されること() {
        // arrange
        let input = ProfileDataObjectBuilder()
            .station(nil)
            .build()

        // act
        let actual = converter.convert(input)

        // assert
        XCTAssertEqual(
            actual,
            ProfileModelObjectBuilder()
                .station(.noSetting)
                .build()
        )
    }
}
