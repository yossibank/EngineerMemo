import XCTest
@testable import EngineerMemo

final class UIViewControllerExtensionTests: XCTestCase {
    func test_addSubviewController() {
        // arrange
        let parentViewController = UIViewController()
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()

        // act
        parentViewController.addSubviewController(viewController1)
        parentViewController.addSubviewController(viewController2)

        // assert
        XCTAssertEqual(
            parentViewController.children,
            [viewController1, viewController2]
        )
    }

    func test_removeSubviewController() {
        // arrange
        let parentViewController = UIViewController()
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()

        parentViewController.addSubviewController(viewController1)
        parentViewController.addSubviewController(viewController2)

        // act
        parentViewController.removeSubviewController(child: viewController1)

        // assert
        XCTAssertEqual(
            parentViewController.children,
            [viewController2]
        )
    }

    func test_removeFirstChild() {
        // arrange
        let parentViewController = UIViewController()
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()

        parentViewController.addSubviewController(viewController1)
        parentViewController.addSubviewController(viewController2)

        // act
        parentViewController.removeFirstChild()

        // assert
        XCTAssertEqual(
            parentViewController.children,
            [viewController2]
        )
    }
}
