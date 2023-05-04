#if DEBUG
    import Foundation

    final class MemoDataObjectBuilder {
        private var category: Memo.Category? = .technical
        private var content: String? = "コンテンツ"
        private var identifier = "identifier"
        private var title: String? = "タイトル"

        func build() -> Memo {
            let context = CoreDataManager.shared.backgroundContext!
            let memo = Memo(context: context)
            memo.category = category
            memo.content = content
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
