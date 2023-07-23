import Foundation

enum AppGroups {
    static let applicationGroupIdentifier = "group."
        + "\((Bundle.main.bundleIdentifier ?? "").replacingOccurrences(of: ".widgets", with: ""))"

    static var containerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: applicationGroupIdentifier
        )!
    }
}
