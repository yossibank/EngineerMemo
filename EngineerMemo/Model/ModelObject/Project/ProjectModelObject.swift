import Foundation

struct ProjectModelObject: Hashable {
    var title: String?
    var content: String?
    var identifier: String
}

extension ProjectModelObject {
    func insertProject(
        profile: CoreDataObject<Profile>,
        project: CoreDataObject<Project>,
        isNew: Bool
    ) {
        let context = profile.context
        let profile = profile.object
        let project = project.object
        project.title = title
        project.content = content

        if isNew {
            project.identifier = UUID().uuidString
        }

        profile.addToProjects(project)

        context.saveIfNeeded()
    }
}
