@testable import EngineerMemo
import iOSSnapshotTestCase
import UIKit

enum SnapshotTest {
    static let recordMode = false
}

enum SnapshotViewMode {
    case normal(UIViewController)
    case navigation(UIViewController)
}

enum SnapshotColorMode: Int, CaseIterable {
    case light = 1
    case dark

    var identifier: String {
        switch self {
        case .light:
            return "Light"

        case .dark:
            return "Dark"
        }
    }
}

extension FBSnapshotTestCase {
    func callViewControllerAppear(vc: UIViewController) {
        vc.beginAppearanceTransition(true, animated: false)
        vc.endAppearanceTransition()
    }

    func snapshotVerifyView(
        viewMode: SnapshotViewMode,
        viewFrame: CGRect = UIWindow.windowFrame,
        viewAfter: CGFloat = .zero,
        viewAction: VoidBlock? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        SnapshotColorMode.allCases.forEach { colorMode in
            snapshotVerifyView(
                colorMode: colorMode,
                viewMode: viewMode,
                viewFrame: viewFrame,
                viewAfter: viewAfter,
                viewAction: viewAction,
                file: file,
                line: line
            )
        }
    }
}

private extension FBSnapshotTestCase {
    func snapshotVerifyView(
        colorMode: SnapshotColorMode,
        viewMode: SnapshotViewMode,
        viewFrame: CGRect = UIWindow.windowFrame,
        viewAfter: CGFloat = .zero,
        viewAction: VoidBlock? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        fileNameOptions = [.device, .OS, .screenSize, .screenScale]

        let window = UIWindow(windowScene: UIWindow.connectedWindowScene!)
        window.frame = viewFrame

        switch viewMode {
        case let .normal(viewController):
            window.rootViewController = viewController

        case let .navigation(viewController):
            window.rootViewController = UINavigationController(rootViewController: viewController)
        }

        window.overrideUserInterfaceStyle = colorMode == .light ? .light : .dark
        window.makeKeyAndVisible()

        viewAction?()

        wait(timeout: viewAfter + 3.0) { expectation in
            Task { @MainActor in
                try await Task.sleep(seconds: viewAfter)

                FBSnapshotVerifyView(
                    window,
                    identifier: colorMode.identifier,
                    overallTolerance: 0.005,
                    file: file,
                    line: line
                )

                expectation.fulfill()
            }
        }
    }
}
