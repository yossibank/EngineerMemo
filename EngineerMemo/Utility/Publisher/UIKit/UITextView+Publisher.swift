import Combine
import UIKit

extension UITextView {
    var textDidChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter
            .default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextView }
            .compactMap(\.text)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
