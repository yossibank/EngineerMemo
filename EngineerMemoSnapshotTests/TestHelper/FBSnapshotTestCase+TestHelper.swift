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
        /// CI/CD環境でスナップショットが撮れないためTaskで囲む
        /// スナップショットを新しく撮るときはTaskを外す
        Task { @MainActor in
            for colorMode in SnapshotColorMode.allCases {
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
        fileNameOptions = [.screenSize]

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
                try await Task.sleep(seconds: 0.5 + viewAfter)

                FBSnapshotVerifyView(
                    window,
                    identifier: colorMode.identifier,
                    overallTolerance: 0.01,
                    file: file,
                    line: line
                )

                expectation.fulfill()
            }
        }
    }
}
