#if DEBUG
    final class SampleDataObjectBuilder {
        private var userId = 1
        private var id = 1
        private var title = "sample title"
        private var body = "sample body"

        func build() -> SampleDataObject {
            .init(
                userId: userId,
                id: id,
                title: title,
                body: body
            )
        }

        func userId(_ userId: Int) -> Self {
            self.userId = userId
            return self
        }

        func id(_ id: Int) -> Self {
            self.id = id
            return self
        }

        func title(_ title: String) -> Self {
            self.title = title
            return self
        }

        func body(_ body: String) -> Self {
            self.body = body
            return self
        }
    }
#endif
