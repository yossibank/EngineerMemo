#if DEBUG
    import UIKit

    enum DebugCoreDataMenuType: CaseIterable {
        case profile
        case skill
        case project
        case memo

        var title: String {
            switch self {
            case .profile:
                return L10n.Debug.CoreData.profile

            case .skill:
                return L10n.Debug.CoreData.skill

            case .project:
                return L10n.Debug.CoreData.project

            case .memo:
                return L10n.Debug.CoreData.memo
            }
        }

        var listViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.List.Profile()

            case .skill:
                return AppControllers.Debug.CoreDataObject.List.Skill()

            case .project:
                return AppControllers.Debug.CoreDataObject.List.Project()

            case .memo:
                return AppControllers.Debug.CoreDataObject.List.Memo()
            }
        }

        var createViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.Create.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.Create.Memo()

            default:
                fatalError(.noSetting)
            }
        }

        var updateViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.Update.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.Update.Memo()

            default:
                fatalError(.noSetting)
            }
        }
    }
#endif
