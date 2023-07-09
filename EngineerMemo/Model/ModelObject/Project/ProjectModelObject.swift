import Foundation

struct ProjectModelObject: Hashable {
    var title: String?
    var role: String?
    var processes: [Int] = []
    var content: String?
    var startDate: Date?
    var endDate: Date?
    var identifier: String
}
