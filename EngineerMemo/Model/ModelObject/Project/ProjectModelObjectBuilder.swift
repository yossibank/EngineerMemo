#if DEBUG
    import Foundation

    final class ProjectModelObjectBuilder {
        private var content: String? = "テストプロジェクト内容"
        private var identifier = "identifier"
        private var title: String? = "テストプロジェクトタイトル"

        func build() -> ProjectModelObject {
            .init(
                title: title,
                content: content,
                identifier: identifier
            )
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
