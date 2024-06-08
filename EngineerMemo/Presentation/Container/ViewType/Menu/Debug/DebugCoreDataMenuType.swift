#if DEBUG
    import UIKit

    enum DebugCoreDataMenuType: CaseIterable {
        case profile
        case skill
        case project
        case memo

        var title: String {
            switch self {
            case .profile: L10n.Debug.CoreData.profile
            case .skill: L10n.Debug.CoreData.skill
            case .project: L10n.Debug.CoreData.project
            case .memo: L10n.Debug.CoreData.memo
            }
        }

        var listViewController: UIViewController {
            switch self {
            case .profile: AppControllers.Debug.CoreDataObject.List.Profile()
            case .skill: AppControllers.Debug.CoreDataObject.List.Skill()
            case .project: AppControllers.Debug.CoreDataObject.List.Project()
            case .memo: AppControllers.Debug.CoreDataObject.List.Memo()
            }
        }

        var createViewController: UIViewController {
            switch self {
            case .profile: AppControllers.Debug.CoreDataObject.Create.Profile()
            case .memo: AppControllers.Debug.CoreDataObject.Create.Memo()
            default: fatalError(.noSetting)
            }
        }

        var updateViewController: UIViewController {
            switch self {
            case .profile: AppControllers.Debug.CoreDataObject.Update.Profile()
            case .memo: AppControllers.Debug.CoreDataObject.Update.Memo()
            default: fatalError(.noSetting)
            }
        }
    }
#endif
