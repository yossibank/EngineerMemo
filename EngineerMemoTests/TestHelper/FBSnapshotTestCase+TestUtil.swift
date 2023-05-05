@testable import EngineerMemo
import iOSSnapshotTestCase

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
            return "ライトモード"

        case .dark:
            return "ダークモード"
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
        viewFrame: CGRect = UIScreen.main.bounds,
        viewAfter: CGFloat = .zero,
        viewAction: VoidBlock? = nil
    ) {
        SnapshotColorMode.allCases.forEach { colorMode in
            snapshotVerifyView(
                colorMode: colorMode,
                viewMode: viewMode,
                viewFrame: viewFrame,
                viewAfter: viewAfter,
                viewAction: viewAction
            )
        }
    }
}

private extension FBSnapshotTestCase {
    func snapshotVerifyView(
        colorMode: SnapshotColorMode,
        viewMode: SnapshotViewMode,
        viewFrame: CGRect = UIScreen.main.bounds,
        viewAfter: CGFloat = .zero,
        viewAction: VoidBlock? = nil
    ) {
        fileNameOptions = [.device, .OS, .screenSize, .screenScale]

        let expectation = XCTestExpectation(description: #function)

        switch viewMode {
        case let .normal(vc):
            vc.view.frame = viewFrame

            let window = UIWindow(frame: vc.view.frame)
            window.rootViewController = vc
            window.overrideUserInterfaceStyle = colorMode == .light ? .light : .dark
            window.makeKeyAndVisible()

            viewAction?()

            vc.view.layoutIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + viewAfter) {
                self.FBSnapshotVerifyView(
                    window,
                    identifier: colorMode.identifier
                )

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 3.0 + viewAfter)

        case let .navigation(vc):
            vc.view.frame = viewFrame

            let window = UIWindow(frame: vc.view.frame)
            let nc = UINavigationController(rootViewController: vc)
            window.rootViewController = nc
            window.overrideUserInterfaceStyle = colorMode == .light ? .light : .dark
            window.makeKeyAndVisible()

            viewAction?()

            vc.view.layoutIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + viewAfter) {
                self.FBSnapshotVerifyView(
                    window,
                    identifier: colorMode.identifier
                )

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 3.0 + viewAfter)
        }
    }
}
