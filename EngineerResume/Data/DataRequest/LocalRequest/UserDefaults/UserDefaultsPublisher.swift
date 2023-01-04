import Combine
import Foundation

extension UserDefaults {
    final class Publisher<Output: UserDefaultsCompatible & Equatable>: NSObject, Combine.Publisher {
        typealias Failure = Never

        var value: Output {
            get {
                subject.value
            }
            set {
                if newValue != subject.value {
                    subject.value = newValue
                    userDefaults.setValue(newValue, forKey: key)
                }
            }
        }

        private let key: String
        private let defaultValue: Output
        private let userDefaults: UserDefaultsProtocol
        private let subject: CurrentValueSubject<Output, Never>

        init(
            key: String,
            default defaultValue: Output,
            userDefaults: UserDefaultsProtocol
        ) {
            self.key = key
            self.defaultValue = defaultValue
            self.userDefaults = userDefaults
            self.subject = .init(userDefaults.value(
                type: Output.self,
                forKey: key,
                default: defaultValue
            ))

            super.init()

            userDefaults.addObserver(
                self,
                forKeyPath: key,
                options: .new,
                context: nil
            )
        }

        deinit {
            userDefaults.removeObserver(
                self,
                forKeyPath: key
            )
        }

        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey: Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            if keyPath == key {
                if let newObject = change?[.newKey] {
                    value = Output(userDefaultsObject: newObject) ?? defaultValue
                } else {
                    value = defaultValue
                }
            }
        }

        func receive<S>(
            subscriber: S
        ) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            subject.receive(subscriber: subscriber)
        }
    }
}
