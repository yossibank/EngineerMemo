#if DEBUG
    import UIKit

    enum DebugDevelopmentSection: Int, CaseIterable {
        case git = 0
        case device
        case coreData

        var title: String {
            switch self {
            case .git:
                return L10n.Debug.Section.git

            case .device:
                return L10n.Debug.Section.device

            case .coreData:
                return L10n.Debug.Section.coreData
            }
        }

        var items: [DebugDevelopmentItem] {
            switch self {
            case .git:
                return [
                    .init(title: L10n.Debug.Git.commitHash, subTitle: Git.commitHash)
                ]

            case .device:
                return [
                    .init(title: L10n.Debug.Device.version, subTitle: UIDevice.current.systemVersion),
                    .init(title: L10n.Debug.Device.name, subTitle: UIDevice.current.name),
                    .init(title: L10n.Debug.Device.udid, subTitle: UIDevice.deviceId)
                ]

            case .coreData:
                return [
                    .init(title: L10n.Debug.CoreData.profile)
                ]
            }
        }
    }

    struct DebugDevelopmentItem: Hashable {
        var title: String
        var subTitle: String?
    }
#endif
