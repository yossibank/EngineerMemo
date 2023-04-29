#if DEBUG
    import Foundation

    final class SKillModelObjectBuilder {
        private var career: Int? = 3

        func build() -> SkillModelObject {
            .init(career: career)
        }

        func career(_ career: Int?) -> Self {
            self.career = career
            return self
        }
    }
#endif
