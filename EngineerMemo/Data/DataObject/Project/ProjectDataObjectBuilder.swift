#if DEBUG
    import CoreData
    import Foundation

    final class ProjectDataObjectBuilder {
        private var content: String? = "テストプロジェクト内容"
        private var endDate = Calendar.date(year: 2021, month: 12, day: 1)
        private var identifier = "identifier"
        private var startDate = Calendar.date(year: 2020, month: 1, day: 1)
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
            project.endDate = endDate
            project.identifier = identifier
            project.startDate = startDate
            project.title = title
            project.profile = profile
            return project
        }

        func content(_ content: String?) -> Self {
            self.content = content
            return self
        }

        func endDate(_ endDate: Date?) -> Self {
            self.endDate = endDate
            return self
        }

        func identifier(_ identifier: String) -> Self {
            self.identifier = identifier
            return self
        }

        func startDate(_ startDate: Date?) -> Self {
            self.startDate = startDate
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
