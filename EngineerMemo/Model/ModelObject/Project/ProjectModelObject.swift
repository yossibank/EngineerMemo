import Foundation

struct ProjectModelObject: Hashable {
    var title: String?
    var content: String?
    var identifier: String
}

extension ProjectModelObject {
    func projectInsert(
        _ project: Project,
        isNew: Bool
    ) {
        project.title = title
        project.content = content

        if isNew {
            project.identifier = UUID().uuidString
        }
    }
}
