#if DEBUG
    import CoreData
    import Foundation

    final class ProjectDataObjectBuilder {
        private var content: String? = "テストプロジェクト内容"
        private var identifier = "identifier"
        private var title: String? = "テストプロジェクトタイトル"
        private var profile: Profile?

        func build() -> Project {
            let context = CoreDataManager.shared.backgroundContext!
            let project = Project(
                entity: NSEntityDescription.entity(
                    forEntityName: Project.className,
                    in: context
                )!,
                insertInto: context
            )
            project.content = content
            project.identifier = identifier
            project.title = title
            project.profile = profile
            return project
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

        func profile(_ profile: Profile?) -> Self {
            self.profile = profile
            return self
        }
    }
#endif
