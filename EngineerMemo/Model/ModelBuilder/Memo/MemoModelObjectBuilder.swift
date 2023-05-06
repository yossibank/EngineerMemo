#if DEBUG
    import Foundation

    final class MemoModelObjectBuilder {
        private var category: MemoModelObject.Category? = .technical
        private var title: String? = "タイトル"
        private var content: String? = "コンテンツ"
        private var createdAt = Calendar.date(year: 2000, month: 1, day: 1)!
        private var identifier = "identifier"

        func build() -> MemoModelObject {
            .init(
                category: category,
                title: title,
                content: content,
                createdAt: createdAt,
                identifier: identifier
            )
        }

        func category(_ category: MemoModelObject.Category?) -> Self {
            self.category = category
            return self
        }

        func title(_ title: String?) -> Self {
            self.title = title
            return self
        }

        func content(_ content: String?) -> Self {
            self.content = content
            return self
        }

        func createdAt(_ createdAt: Date) -> Self {
            self.createdAt = createdAt
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }
    }
#endif
