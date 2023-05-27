import UIKit

private extension UIApplication {
    static var isXCTesting: Bool {
        NSClassFromString("XCTestCase") != nil
    }
}

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(NSClassFromString("AppDelegateMock") ?? AppDelegate.self)
)
