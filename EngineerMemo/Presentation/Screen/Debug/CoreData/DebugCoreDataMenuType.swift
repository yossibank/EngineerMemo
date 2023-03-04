#if DEBUG
    import UIKit

    enum DebugCoreDataMenuType: CaseIterable {
        case profile
        case memo
        case sample2

        var title: String {
            switch self {
            case .profile:
                return L10n.Debug.CoreData.profile

            case .memo:
                return L10n.Debug.CoreData.memo

            case .sample2:
                return "サンプル2"
            }
        }

        var listViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.List.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.List.Memo()

            case .sample2:
                let vc = UIViewController()
                vc.view.backgroundColor = .yellow
                return vc
            }
        }

        var createViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.Create.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.Create.Memo()

            case .sample2:
                let vc = UIViewController()
                vc.view.backgroundColor = .yellow
                return vc
            }
        }

        var updateViewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.Update.Profile()

            case .memo:
                return AppControllers.Debug.CoreDataObject.Update.Memo()

            case .sample2:
                let vc = UIViewController()
                vc.view.backgroundColor = .yellow
                return vc
            }
        }
    }
#endif
