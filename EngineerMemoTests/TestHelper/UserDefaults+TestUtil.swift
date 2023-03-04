@testable import EngineerMemo
import XCTest

extension XCTestCase {
    func resetUserDefaults() {
        let userDefault = UserDefaults(suiteName: "test")

        UserDefaultsKey.allCases.forEach {
            userDefault?.removeObject(forKey: $0.rawValue)
        }

        userDefault?.removePersistentDomain(forName: "test")
    }
}
