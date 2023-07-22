import Foundation

enum AppGroups {
    static let applicationGroupIdentifier = "group." + (Bundle.main.bundleIdentifier ?? .empty)

    static var containerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: applicationGroupIdentifier
        )!
    }
}
