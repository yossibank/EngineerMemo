import Foundation

struct Git {
    static let commitHash: String = {
        guard let bundleInfo = Bundle.main.infoDictionary else {
            return .unknown
        }

        return bundleInfo["CommitHash"] as? String ?? .unknown
    }()
}
