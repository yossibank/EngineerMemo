import Foundation

extension UserDefaults {
    private(set) static var shared = UserDefaults(suiteName: AppGroups.applicationGroupIdentifier)

    static func inject(_ userDefaults: UserDefaults) {
        shared = userDefaults
    }
}

extension UserDefaults {
    static let isUserDefaultsMigratedKey = "isUserDefaultsMigrated"

    static func migrate(
        to toUserDefaults: UserDefaults?,
        from fromUserDefaults: UserDefaults?
    ) {
        guard
            let toUserDefaults,
            let fromUserDefaults
        else {
            return
        }

        if !toUserDefaults.bool(forKey: isUserDefaultsMigratedKey) {
            for (key, value) in fromUserDefaults.dictionaryRepresentation() {
                toUserDefaults.set(value, forKey: key)
            }

            toUserDefaults.setValue(true, forKey: isUserDefaultsMigratedKey)
            toUserDefaults.synchronize()

            Logger.info(message: "UserDefaultsのマイグレーション完了")
        } else {
            Logger.info(message: "UserDefaultsのマイグレーション完了済み")
        }
    }
}
