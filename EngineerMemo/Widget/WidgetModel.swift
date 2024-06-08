import Foundation

enum WidgetModel {
    static var memoList: [MemoModelObject] {
        CoreDataStorage<Memo>().allObjects
            .filter { $0.category == .widget }
            .map {
                .init(
                    category: .init(rawValue: $0.category?.rawValue ?? .invalid),
                    title: $0.title ?? .noSetting,
                    content: $0.content ?? .noSetting,
                    createdAt: $0.createdAt ?? .init(),
                    identifier: $0.identifier
                )
            }
            .sorted(by: { $0.createdAt > $1.createdAt })
    }
}
