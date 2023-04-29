#if DEBUG
    import Foundation

    final class SKillModelObjectBuilder {
        private var career: Int? = 3
        private var identifier = "identifier"

        func build() -> SkillModelObject {
            .init(
                career: career,
                identifier: identifier
            )
        }

        func career(_ career: Int?) -> Self {
            self.career = career
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }
    }
#endif
