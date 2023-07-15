#if DEBUG
    import CoreData
    import Foundation

    final class ProjectDataObjectBuilder {
        private var content: String? = "テストプロジェクト内容"
        private var database: String? = "CoreData"
        private var endDate = Calendar.date(year: 2021, month: 12, day: 1)
        private var identifier = "identifier"
        private var language: String? = "Swift5.8"
        private var processes = [1, 3, 5]
        private var role: String? = "プログラマー"
        private var serverOS: String? = "Ubuntu"
        private var startDate = Calendar.date(year: 2020, month: 1, day: 1)
        private var title: String? = "テストプロジェクトタイトル"
        private var tools = ["Firebase", "MagicPod"]
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
            project.database = database
            project.endDate = endDate
            project.identifier = identifier
            project.language = language
            project.processes = processes
            project.role = role
            project.serverOS = serverOS
            project.startDate = startDate
            project.title = title
            project.tools = tools
            project.profile = profile
            return project
        }

        func content(_ content: String?) -> Self {
            self.content = content
            return self
        }

        func database(_ database: String?) -> Self {
            self.database = database
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

        func language(_ language: String?) -> Self {
            self.language = language
            return self
        }

        func processes(_ processes: [Int]) -> Self {
            self.processes = processes
            return self
        }

        func role(_ role: String?) -> Self {
            self.role = role
            return self
        }

        func serverOS(_ serverOS: String?) -> Self {
            self.serverOS = serverOS
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

        func tools(_ tools: [String]) -> Self {
            self.tools = tools
            return self
        }

        func profile(_ profile: Profile?) -> Self {
            self.profile = profile
            return self
        }
    }
#endif
