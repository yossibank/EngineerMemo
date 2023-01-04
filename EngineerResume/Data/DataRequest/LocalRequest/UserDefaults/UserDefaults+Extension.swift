import Foundation

extension UserDefaults {
    private(set) static var shared = UserDefaults.standard

    static func inject(_ userDefaults: UserDefaults) {
        shared = userDefaults
    }
}
