import XCTest

final class ProfileListPageUITest: XCTestCase {
    private var app: XCUIApplication!
    private var page: ProfileListPage!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        app = .init()
        page = .init(app: app)

        app.launch()
    }

    func test_プロフィール詳細画面_初期表示時にプロフィール画像変更ボタンが押下できないこと() {
        XCTAssertTrue(page.exist)
        XCTAssertFalse(page.iconChangeButton.isEnabled)
        XCTAssertTrue(
            page.existElements(
                [page.iconImageView],
                timeout: 2.0
            )
        )
    }
}
