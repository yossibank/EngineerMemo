import Foundation

enum AppConfig {
    static var appStoreReviewURL: URL? {
        URL(string: "https://apps.apple.com/us/app/%E3%82%A8%E3%83%B3%E3%83%A1%E3%83%A2/id6450376037?action=write-review")
    }

    static var applicationVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    static var acknowledgements: String? {
        guard
            let path = Bundle.main.path(
                forResource: "Acknowledgements",
                ofType: "plist",
                inDirectory: "Settings.bundle"
            ),
            let contents = NSDictionary(contentsOfFile: path),
            let acknowledgements = contents["PreferenceSpecifiers"] as? [[String: Any]]
        else {
            return nil
        }

        return acknowledgements.reduce(into: "") {
            guard
                let title = $1["Title"],
                let footerText = $1["FooterText"]
            else {
                return
            }

            $0 += "\(title)\n\n\(footerText)\n\n\n"
        }
    }
}
