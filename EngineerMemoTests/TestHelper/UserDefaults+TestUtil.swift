@testable import EngineerMemo
import XCTest

extension XCTestCase {
    func resetUserDefaults() {
        UserDefaults(suiteName: "test")?.removePersistentDomain(forName: "test")
    }
}
