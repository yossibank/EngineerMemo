#if DEBUG
    import Foundation

    final class SKillModelObjectBuilder {
        private var career: Int? = 3
        private var toeic: Int? = 600
        private var identifier = "identifier"

        func build() -> SkillModelObject {
            .init(
                career: career,
                toeic: toeic,
                identifier: identifier
            )
        }

        func career(_ career: Int?) -> Self {
            self.career = career
            return self
        }

        func toeic(_ toeic: Int?) -> Self {
            self.toeic = toeic
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }
    }
#endif
