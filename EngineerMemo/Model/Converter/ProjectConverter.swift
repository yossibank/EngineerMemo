/// @mockable
protocol ProjectConverterInput {
    func convert(_ projects: [Project]?) -> [ProjectModelObject]
    func convert(_ project: Project) -> ProjectModelObject
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

    func convert(_ project: Project) -> ProjectModelObject {
        /// NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        .init(
            title: project.title,
            content: project.content,
            identifier: project.identifier
        )
    }
}
