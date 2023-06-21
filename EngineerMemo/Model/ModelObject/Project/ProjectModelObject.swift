import Foundation

struct ProjectModelObject: Hashable {
    var title: String?
    var content: String?
    var identifier: String
}

extension ProjectModelObject {
    func projectInsert(
        _ data: CoreDataObject<Project>,
        isNew: Bool
    ) {
        let project = data.object
        project.title = title
        project.content = content

        if isNew {
            project.identifier = UUID().uuidString
        }

        data.context.saveIfNeeded()
    }
}
