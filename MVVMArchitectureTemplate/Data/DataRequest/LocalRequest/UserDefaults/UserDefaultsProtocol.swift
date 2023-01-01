import Foundation

protocol UserDefaultsProtocol: NSObject {
    func value<Value: UserDefaultsCompatible>(
        type: Value.Type,
        forKey key: String,
        default defaultValue: Value
    ) -> Value

    func setValue<Value: UserDefaultsCompatible>(
        _ value: Value,
        forKey key: String
    )
}

extension UserDefaults: UserDefaultsProtocol {
    func value<Value: UserDefaultsCompatible>(
        type: Value.Type,
        forKey key: String,
        default defaultValue: Value
    ) -> Value {
        guard let object = object(forKey: key) else {
            return defaultValue
        }

        return Value(userDefaultsObject: object) ?? defaultValue
    }

    func setValue(
        _ value: some UserDefaultsCompatible,
        forKey key: String
    ) {
        set(
            value.toUserDefaultsObject(),
            forKey: key
        )
    }
}
