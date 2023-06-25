import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Hashable {
    var unique: [Element] {
        var set = Set<Element>()

        return filter {
            set.insert($0).inserted
        }
    }
}

extension Array where Element: Equatable {
    mutating func replace(
        before: Array.Element,
        after: Array.Element
    ) {
        self = map {
            ($0 == before) ? after : $0
        }
    }
}
