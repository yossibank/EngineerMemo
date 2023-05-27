#if DEBUG
    import Foundation

    final class SKillModelObjectBuilder {
        private var engineerCareer: Int? = 3
        private var language: String? = "Swift"
        private var languageCareer: Int? = 2
        private var toeic: Int? = 600
        private var identifier = "identifier"

        func build() -> SkillModelObject {
            .init(
                engineerCareer: engineerCareer,
                language: language,
                languageCareer: languageCareer,
                toeic: toeic,
                identifier: identifier
            )
        }

        func engineerCareer(_ engineerCareer: Int?) -> Self {
            self.engineerCareer = engineerCareer
            return self
        }

        func language(_ language: String?) -> Self {
            self.language = language
            return self
        }

        func languageCareer(_ languageCareer: Int?) -> Self {
            self.languageCareer = languageCareer
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
