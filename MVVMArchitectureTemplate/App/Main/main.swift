import UIKit

private extension UIApplication {
    static var isXCTesting: Bool {
        NSClassFromString("XCTestCase") != nil
    }
}

private func delegateClassName() -> String {
    UIApplication.isXCTesting
        ? "MVVMArchitectureTemplateTests.AppDelegate"
        : NSStringFromClass(AppDelegate.self)
}

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    delegateClassName()
)
