#if DEBUG
    import Foundation

    final class ProjectModelObjectBuilder {
        private var title: String? = "テストプロジェクトタイトル"
        private var role: String? = "プログラマー"
        private var processes: [ProjectModelObject.Process] = [.technicalDesign, .implementation]
        private var language: String? = "Swift5.8"
        private var database: String? = "CoreData"
        private var serverOS: String? = "Ubuntu"
        private var tools = ["Firebase", "MagicPod"]
        private var content: String? = "テストプロジェクト内容"
        private var startDate = Calendar.date(year: 2020, month: 1, day: 1)
        private var endDate = Calendar.date(year: 2021, month: 12, day: 1)
        private var identifier = "identifier"

        func build() -> ProjectModelObject {
            .init(
                title: title,
                role: role,
                processes: processes,
                language: language,
                database: database,
                serverOS: serverOS,
                tools: tools,
                content: content,
                startDate: startDate,
                endDate: endDate,
                identifier: identifier
            )
        }

        func title(_ title: String?) -> Self {
            self.title = title
            return self
        }

        func role(_ role: String?) -> Self {
            self.role = role
            return self
        }

        func processes(_ processes: [ProjectModelObject.Process]) -> Self {
            self.processes = processes
            return self
        }

        func language(_ language: String?) -> Self {
            self.language = language
            return self
        }

        func database(_ database: String?) -> Self {
            self.database = database
            return self
        }

        func serverOS(_ serverOS: String?) -> Self {
            self.serverOS = serverOS
            return self
        }

        func tools(_ tools: [String]) -> Self {
            self.tools = tools
            return self
        }

        func content(_ content: String?) -> Self {
            self.content = content
            return self
        }

        func startDate(_ startDate: Date?) -> Self {
            self.startDate = startDate
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
    }
#endif
