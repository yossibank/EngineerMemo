@testable import EngineerMemo
import XCTest

final class UserDefaultsMigrateTest: XCTestCase {
    private var toUserDefaults: UserDefaults!
    private var fromUserDefaults: UserDefaults!

    override func setUp() {
        super.setUp()

        toUserDefaults = .init(suiteName: "toUserDefaults")
        fromUserDefaults = .init(suiteName: "fromUserDefaults")
    }

    override func tearDown() {
        super.tearDown()

        toUserDefaults.removePersistentDomain(forName: "toUserDefaults")
        fromUserDefaults.removePersistentDomain(forName: "fromUserDefaults")
    }

    func test_migrate_値を引き継げていること() {
        // arrange
        fromUserDefaults.setValue(12345, forKey: "test")

        // act
        UserDefaults.migrate(
            to: toUserDefaults,
            from: fromUserDefaults
        )

        // assert
        XCTAssertEqual(
            toUserDefaults.integer(forKey: "test"),
            12345
        )
    }
}
