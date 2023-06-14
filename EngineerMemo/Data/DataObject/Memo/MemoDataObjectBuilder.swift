#if DEBUG
    import CoreData
    import Foundation

    final class MemoDataObjectBuilder {
        private var category: Memo.Category? = .technical
        private var content: String? = "コンテンツ"
        private var createdAt = Calendar.date(year: 2000, month: 1, day: 1)
        private var identifier = "identifier"
        private var title: String? = "タイトル"

        func build() -> Memo {
            let context = CoreDataManager.shared.backgroundContext!
            let memo = Memo(
                entity: NSEntityDescription.entity(
                    forEntityName: Memo.className,
                    in: context
                )!,
                insertInto: context
            )
            memo.category = category
            memo.content = content
            memo.createdAt = createdAt
            memo.identifier = identifier
            memo.title = title
            return memo
        }

        func category(_ category: Memo.Category?) -> Self {
            self.category = category
            return self
        }

        func content(_ content: String?) -> Self {
            self.content = content
            return self
        }

        func createdAt(_ createdAt: Date?) -> Self {
            self.createdAt = createdAt
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }

        func title(_ title: String?) -> Self {
            self.title = title
            return self
        }
    }
#endif
