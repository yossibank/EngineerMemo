import Foundation

enum AppConfig {
    static let appReviewURL = URL(
        string: "https://apps.apple.com/us/app/%E3%82%A8%E3%83%B3%E3%83%A1%E3%83%A2/id6450376037?action=write-review"
    )

    static let appMailURL = URL(string: "mailTo:")

    static let appInquiryAddress = "engineermemo29@gmail.com"

    static let applicationVersion = Bundle.main.object(
        forInfoDictionaryKey: "CFBundleShortVersionString"
    ) as! String

    static let acknowledgements: String? = {
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
    }()
}
