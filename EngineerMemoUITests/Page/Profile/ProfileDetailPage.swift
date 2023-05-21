import XCTest

final class ProfileDetailPage: PageObjectable {
    enum Ally {
        static let title = "プロフィール"
        static let iconImageView = "ProfileTopCell.iconImageView"
        static let iconChangeButton = "ProfileTopCell.iconChangeButton"
    }

    var pageTitle: XCUIElement {
        app.navigationBars[Ally.title].firstMatch
    }

    var iconImageView: XCUIElement {
        app.images[Ally.iconImageView].firstMatch
    }

    var iconChangeButton: XCUIElement {
        app.buttons[Ally.iconChangeButton].firstMatch
    }

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }
}
