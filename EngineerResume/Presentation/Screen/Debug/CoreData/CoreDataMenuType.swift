#if DEBUG
    import UIKit

    enum CoreDataMenuType: CaseIterable {
        case profile
        case sample1
        case sample2

        var title: String {
            switch self {
            case .profile:
                return "プロフィール"

            case .sample1:
                return "サンプル1"

            case .sample2:
                return "サンプル2"
            }
        }

        var viewController: UIViewController {
            switch self {
            case .profile:
                return AppControllers.Debug.CoreDataObject.Profile()

            case .sample1:
                let vc = UIViewController()
                vc.view.backgroundColor = .blue
                return vc

            case .sample2:
                let vc = UIViewController()
                vc.view.backgroundColor = .yellow
                return vc
            }
        }
    }
#endif
