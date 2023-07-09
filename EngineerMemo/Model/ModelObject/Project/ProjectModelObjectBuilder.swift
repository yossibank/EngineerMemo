#if DEBUG
    import Foundation

    final class ProjectModelObjectBuilder {
        private var content: String? = "テストプロジェクト内容"
        private var role: String? = "プログラマー"
        private var processes = [1, 3, 5]
        private var title: String? = "テストプロジェクトタイトル"
        private var startDate = Calendar.date(year: 2020, month: 1, day: 1)
        private var endDate = Calendar.date(year: 2021, month: 12, day: 1)
        private var identifier = "identifier"

        func build() -> ProjectModelObject {
            .init(
                title: title,
                role: role,
                processes: processes,
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

        func processes(_ processes: [Int]) -> Self {
            self.processes = processes
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
