#if DEBUG
    import UIKit

    enum DebugSection: CaseIterable {
        case git
        case device

        var title: String {
            switch self {
            case .git:
                return L10n.Debug.git

            case .device:
                return L10n.Debug.Device.information
            }
        }

        var items: [DebugItem] {
            switch self {
            case .git:
                return [
                    .init(title: L10n.Debug.commitHash, subTitle: Git.commitHash)
                ]

            case .device:
                return [
                    .init(title: L10n.Debug.Device.version, subTitle: UIDevice.current.systemVersion),
                    .init(title: L10n.Debug.Device.name, subTitle: UIDevice.current.name),
                    .init(title: L10n.Debug.Device.udid, subTitle: UIDevice.deviceId)
                ]
            }
        }
    }

    struct DebugItem: Hashable {
        var title: String
        var subTitle: String?
    }
#endif
