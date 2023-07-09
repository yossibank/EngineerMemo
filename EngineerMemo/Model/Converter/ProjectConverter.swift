/// @mockable
protocol ProjectConverterInput {
    func convert(_ projects: [Project]?) -> [ProjectModelObject]
}

struct ProjectConverter: ProjectConverterInput {
    func convert(_ projects: [Project]?) -> [ProjectModelObject] {
        guard let projects else {
            return []
        }

        /// NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        return projects.map { project -> ProjectModelObject in
            convert(project)
        }
    }
}

private extension ProjectConverter {
    func convert(_ project: Project) -> ProjectModelObject {
        /// NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        ProjectModelObject(
            title: project.title,
            role: project.role,
            processes: project.processes,
            content: project.content,
            startDate: project.startDate,
            endDate: project.endDate,
            identifier: project.identifier
        )
    }
}
