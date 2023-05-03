#if DEBUG
    import Foundation

    final class MemoModelObjectBuilder {
        private var category: MemoModelObject.Category? = .technical
        private var content: String? = "コンテンツ"
        private var identifier = "identifier"
        private var title: String? = "タイトル"

        func build() -> MemoModelObject {
            .init(
                category: category,
                title: title,
                content: content,
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

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }
    }
#endif
