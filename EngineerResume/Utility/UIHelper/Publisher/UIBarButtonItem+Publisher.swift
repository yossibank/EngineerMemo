import Combine
import UIKit

extension UIBarButtonItem {
    final class Subscription<
        SubscriberType: Subscriber,
        Input: UIBarButtonItem
    >: Combine.Subscription where SubscriberType.Input == Input {
        private var subscriber: SubscriberType?

        private let input: Input

        init(
            subscriber: SubscriberType,
            input: Input
        ) {
            self.subscriber = subscriber
            self.input = input

            input.target = self
            input.action = #selector(eventHandler)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(input)
        }
    }

    struct Publisher<Output: UIBarButtonItem>: Combine.Publisher {
        typealias Output = Output
        typealias Failure = Never

        let output: Output

        init(output: Output) {
            self.output = output
        }

        func receive<S>(
            subscriber: S
        ) where S: Subscriber, Never == S.Failure, Output == S.Input {
            let subscription = Subscription(
                subscriber: subscriber,
                input: output
            )

            subscriber.receive(subscription: subscription)
        }
    }
}
