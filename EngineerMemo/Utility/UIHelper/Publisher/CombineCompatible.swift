import Combine
import UIKit

protocol CombineCompatible {}

extension UIControl: CombineCompatible {}

extension UIBarButtonItem: CombineCompatible {}

extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControl.Publisher<Self> {
        .init(
            output: self,
            controlEvents: events
        )
    }
}

extension CombineCompatible where Self: UIBarButtonItem {
    var publisher: UIBarButtonItem.Publisher<Self> {
        .init(output: self)
    }
}

extension CombineCompatible where Self: UISwitch {
    var isOnPublisher: AnyPublisher<Bool, Never> {
        publisher(for: [.allEditingEvents, .valueChanged])
            .map(\.isOn)
            .eraseToAnyPublisher()
    }
}

extension CombineCompatible where Self: UISegmentedControl {
    var selectedIndexPublisher: AnyPublisher<Int, Never> {
        publisher(for: [.allEditingEvents, .valueChanged])
            .map(\.selectedSegmentIndex)
            .eraseToAnyPublisher()
    }
}
