@testable import EngineerMemo
import XCTest

final class UserDefaultsStorageTest: XCTestCase {
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()

        userDefaults = .init(suiteName: "test")

        resetUserDefaults()
    }

    override func tearDown() {
        super.tearDown()

        resetUserDefaults()
    }

    func test_String型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("string", defaultValue: "")
        var string: String

        // act
        string = "test"

        // assert
        XCTAssertEqual(
            userDefaults.string(forKey: "string"),
            "test"
        )
    }

    func test_Int型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("int", defaultValue: 0)
        var int: Int

        // act
        int = 100

        // assert
        XCTAssertEqual(
            userDefaults.integer(forKey: "int"),
            100
        )
    }

    func test_Double型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("double", defaultValue: 0.0)
        var double: Double

        // act
        double = 100.1

        // assert
        XCTAssertEqual(
            userDefaults.double(forKey: "double"),
            100.1
        )
    }

    func test_Float型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("float", defaultValue: 0.00)
        var float: Float

        // act
        float = 10.01

        // assert
        XCTAssertEqual(
            userDefaults.float(forKey: "float"),
            10.01
        )
    }

    func test_Bool型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("bool", defaultValue: false)
        var bool: Bool

        // act
        bool = true

        // assert
        XCTAssertEqual(
            userDefaults.bool(forKey: "bool"),
            true
        )
    }

    func test_Optional型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("optional", defaultValue: "")
        var optional: String?

        // act
        optional = nil

        // assert
        XCTAssertEqual(
            userDefaults.string(forKey: "optional"),
            nil
        )
    }

    func test_URL型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("url", defaultValue: URL(string: "sample.com")!)
        var url: URL

        // act
        url = .init(string: "test.com")!

        // assert
        XCTAssertEqual(
            userDefaults.url(forKey: "url"),
            .init(string: "test.com")
        )
    }

    func test_Date型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("date", defaultValue: Date())
        var date: Date

        // act
        date = Calendar.date(year: 2000, month: 1, day: 1)!

        // assert
        XCTAssertEqual(
            userDefaults.object(forKey: "date") as! Date,
            Calendar.date(year: 2000, month: 1, day: 1)!
        )
    }

    func test_Array型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("array", defaultValue: [])
        var array: [String]

        // act
        array = ["a", "b", "c"]

        // assert
        XCTAssertEqual(
            userDefaults.array(forKey: "array") as! [String],
            ["a", "b", "c"]
        )
    }

    func test_Dictionary型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("dictionary", defaultValue: [:])
        var dictionary: [String: String]

        // act
        dictionary = ["a": "test1", "b": "test2", "c": "test3"]

        // assert
        XCTAssertEqual(
            userDefaults.dictionary(forKey: "dictionary") as! [String: String],
            ["a": "test1", "b": "test2", "c": "test3"]
        )
    }

    func test_Data型の値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("data", defaultValue: Data())
        var data: Data

        // act
        data = "test".data(using: .utf8)!

        // assert
        XCTAssertEqual(
            userDefaults.data(forKey: "data"),
            "test".data(using: .utf8)
        )
    }

    func test_RawValue_Enumの値をUserDefaultsStorageで保存できること() {
        // arrange
        @UserDefaultsStorage("enum", defaultValue: .test1)
        var testEnum: TestEnum

        // act
        testEnum = .test3

        // assert
        XCTAssertEqual(
            userDefaults.string(forKey: "enum"),
            TestEnum.test3.rawValue
        )
    }
}

private enum TestEnum: String, UserDefaultsCompatible {
    case test1
    case test2
    case test3
}
