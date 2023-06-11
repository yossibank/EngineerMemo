@testable import EngineerMemo
import XCTest

extension XCTestCase {
    func wait(
        description: String = #function,
        file: StaticString = #file,
        line: UInt = #line,
        timeout: TimeInterval = 0.1,
        closure: (XCTestExpectation) -> Void
    ) {
        let expectation = XCTestExpectation(description: description)
        closure(expectation)

        wait(
            for: expectation,
            timeout: timeout,
            file: file,
            line: line
        )
    }

    func wait(
        for expectation: XCTestExpectation,
        timeout seconds: TimeInterval = 0.1,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let waiter = XCTWaiter().wait(
            for: [expectation],
            timeout: seconds
        )

        let message: String = {
            switch waiter {
            case .completed: return "正常に動作しました"
            case .timedOut: return "期待する結果を取得する前にタイムアウトしました"
            case .incorrectOrder: return "期待する結果の実行順番が異なりました"
            case .invertedFulfillment: return "期待する結果が反転されました"
            case .interrupted: return "期待する結果を取得する前に中断されました"
            @unknown default: return "不明なエラー"
            }
        }()

        XCTAssertTrue(
            waiter == .completed,
            "Expectationエラー: \(message)",
            file: file,
            line: line
        )
    }
}
