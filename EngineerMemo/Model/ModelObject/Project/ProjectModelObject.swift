import Foundation

struct ProjectModelObject: Hashable {
    var title: String?
    var role: String?
    var processes: [Process] = []
    var content: String?
    var startDate: Date?
    var endDate: Date?
    var identifier: String

    enum Process: Int {
        case requirementDefinition
        case functionalDesign
        case technicalDesign
        case implementation
        case intergrationTesting
        case systemTesting
        case maintenance

        var value: String {
            let l10n = L10n.Project.Process.self

            switch self {
            case .requirementDefinition: return l10n.requirementDefinition
            case .functionalDesign: return l10n.funtionalDesign
            case .technicalDesign: return l10n.technicalDesign
            case .implementation: return l10n.implementation
            case .intergrationTesting: return l10n.integrationTesting
            case .systemTesting: return l10n.systemTesting
            case .maintenance: return l10n.maintenance
            }
        }
    }
}
