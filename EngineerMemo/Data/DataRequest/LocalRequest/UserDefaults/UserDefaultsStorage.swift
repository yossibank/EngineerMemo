import Foundation

@propertyWrapper
final class UserDefaultsStorage<Value: UserDefaultsCompatible & Equatable> {
    private let publisher: UserDefaults.Publisher<Value>

    init(
        _ key: UserDefaultsKey,
        defaultValue: Value,
        userDefaults: UserDefaultsProtocol = UserDefaults.shared ?? .standard
    ) {
        self.publisher = .init(
            key: key.rawValue,
            default: defaultValue,
            userDefaults: userDefaults
        )
    }

    init(
        _ key: String,
        defaultValue: Value,
        userDefaults: UserDefaultsProtocol = UserDefaults.shared ?? .standard
    ) {
        self.publisher = .init(
            key: key,
            default: defaultValue,
            userDefaults: userDefaults
        )
    }

    var projectedValue: UserDefaults.Publisher<Value> {
        publisher
    }

    var wrappedValue: Value {
        get {
            publisher.value
        }
        set {
            publisher.value = newValue
        }
    }
}
