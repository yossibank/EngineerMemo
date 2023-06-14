@testable import EngineerMemo
import XCTest

final class TaskExtensionTest: XCTestCase {
    func test_sleep_指定した秒数間待機できてること() async {
        // arrange
        let start = Date()

        // act
        try! await Task.sleep(seconds: 1)

        let end = Date()
        let time = end.timeIntervalSince(start)

        // assert
        XCTAssertTrue(time > 1)
    }
}
