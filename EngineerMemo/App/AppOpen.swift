import UIKit

enum AppOpen {
    static func appReview() {
        guard let appReviewURL = AppConfig.appReviewURL else {
            return
        }

        UIApplication.shared.open(appReviewURL)
    }

    static func appMail() {
        guard let appMailURL = AppConfig.appMailURL else {
            return
        }

        UIApplication.shared.open(appMailURL)
    }
}
