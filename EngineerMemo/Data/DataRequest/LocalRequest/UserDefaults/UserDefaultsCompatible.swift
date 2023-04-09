import Foundation

protocol UserDefaultsCompatible {
    init?(userDefaultsObject: Any)

    func toUserDefaultsObject() -> Any?
}

extension UserDefaultsCompatible where Self: RawRepresentable {
    var description: String {
        String(describing: self)
    }

    init?(userDefaultsObject: Any) {
        guard
            let rawValue = userDefaultsObject as? Self.RawValue,
            let value = Self(rawValue: rawValue)
        else {
            return nil
        }

        self = value
    }

    func toUserDefaultsObject() -> Any? {
        rawValue
    }
}

extension UserDefaultsCompatible where Self: Codable {
    init?(userDefaultsObject: Any) {
        guard let data = userDefaultsObject as? Data else {
            return nil
        }

        do {
            self = try JSONDecoder().decode(
                Self.self,
                from: data
            )
        } catch {
            return nil
        }
    }

    func toUserDefaultsObject() -> Any? {
        try? JSONEncoder().encode(self)
    }
}

extension UserDefaultsCompatible where Self: NSObject, Self: NSCoding {
    init?(userDefaultsObject: Any) {
        guard let data = userDefaultsObject as? Data else {
            return nil
        }

        if let value = try? NSKeyedUnarchiver.unarchivedObject(
            ofClass: Self.self,
            from: data
        ) {
            self = value
        } else {
            return nil
        }
    }

    func toUserDefaultsObject() -> Any? {
        if let object = try? NSKeyedArchiver.archivedData(
            withRootObject: self,
            requiringSecureCoding: false
        ) {
            return object
        } else {
            return nil
        }
    }
}

extension Array: UserDefaultsCompatible where Element: UserDefaultsCompatible {
    private struct UserDefaultsCompatibleError: Error {}

    init?(userDefaultsObject: Any) {
        guard let objects = userDefaultsObject as? [Any] else {
            return nil
        }

        do {
            let values = try objects.map { object -> Element in
                if let element = Element(userDefaultsObject: object) {
                    return element
                } else {
                    throw UserDefaultsCompatibleError()
                }
            }

            self = values
        } catch {
            return nil
        }
    }

    func toUserDefaultsObject() -> Any? {
        map { $0.toUserDefaultsObject() }
    }
}

extension Dictionary: UserDefaultsCompatible where Key == String, Value: UserDefaultsCompatible {
    private struct UserDefaultsCompatibleError: Error {}

    init?(userDefaultsObject: Any) {
        guard let objects = userDefaultsObject as? [String: Any] else {
            return nil
        }

        do {
            let values = try objects.mapValues { object -> Value in
                if let value = Value(userDefaultsObject: object) {
                    return value
                } else {
                    throw UserDefaultsCompatibleError()
                }
            }

            self = values
        } catch {
            return nil
        }
    }

    func toUserDefaultsObject() -> Any? {
        mapValues { $0.toUserDefaultsObject() }
    }
}

extension Optional: UserDefaultsCompatible where Wrapped: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        self = Wrapped(userDefaultsObject: userDefaultsObject)
    }

    func toUserDefaultsObject() -> Any? {
        flatMap { $0.toUserDefaultsObject() }
    }
}

extension Int: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        guard let userDefaultsObject = userDefaultsObject as? Self else {
            return nil
        }

        self = userDefaultsObject
    }

    func toUserDefaultsObject() -> Any? {
        self
    }
}

extension Double: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        guard let userDefaultsObject = userDefaultsObject as? Self else {
            return nil
        }

        self = userDefaultsObject
    }

    func toUserDefaultsObject() -> Any? {
        self
    }
}

extension Float: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        guard let userDefaultsObject = userDefaultsObject as? Self else {
            return nil
        }

        self = userDefaultsObject
    }

    func toUserDefaultsObject() -> Any? {
        self
    }
}

extension Bool: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        guard let userDefaultsObject = userDefaultsObject as? Self else {
            return nil
        }

        self = userDefaultsObject
    }

    func toUserDefaultsObject() -> Any? {
        self
    }
}

extension String: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        guard let userDefaultsObject = userDefaultsObject as? Self else {
            return nil
        }

        self = userDefaultsObject
    }

    func toUserDefaultsObject() -> Any? {
        self
    }
}

extension URL: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        guard
            let data = userDefaultsObject as? Data,
            let url = try? NSKeyedUnarchiver.unarchivedObject(
                ofClass: NSURL.self, from: data
            ) as? URL
        else {
            return nil
        }

        self = url
    }

    func toUserDefaultsObject() -> Any? {
        try? NSKeyedArchiver.archivedData(
            withRootObject: self,
            requiringSecureCoding: false
        )
    }
}

extension Date: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        guard let userDefaultsObject = userDefaultsObject as? Self else {
            return nil
        }

        self = userDefaultsObject
    }

    func toUserDefaultsObject() -> Any? {
        self
    }
}

extension Data: UserDefaultsCompatible {
    init?(userDefaultsObject: Any) {
        guard let userDefaultsObject = userDefaultsObject as? Self else {
            return nil
        }

        self = userDefaultsObject
    }

    func toUserDefaultsObject() -> Any? {
        self
    }
}
