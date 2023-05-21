import XCTest

protocol PageObjectable: AnyObject {
    associatedtype Ally

    var app: XCUIApplication { get }
    var pageTitle: XCUIElement { get }
    var exist: Bool { get }

    func existElements(
        _ elements: [XCUIElement],
        timeout: Double
    ) -> Bool

    init(app: XCUIApplication)
}

extension PageObjectable {
    var app: XCUIApplication {
        .init()
    }

    var exist: Bool {
        existElements(
            [pageTitle],
            timeout: 1.0
        )
    }

    func existElements(
        _ elements: [XCUIElement],
        timeout: Double
    ) -> Bool {
        elements.contains(where: {
            $0.waitForExistence(timeout: timeout)
        })
    }
}
