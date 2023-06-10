#if DEBUG
    import UIKit

    enum DebugCoreDataMenuType: CaseIterable {
        case profile
        case skill
        case memo

        var title: String {
            switch self {
            case .profile:
                return L10n.Debug.CoreData.profile

            case .skill:
                return L10n.Debug.CoreData.skill

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
