@testable import EngineerMemo
import UIKit

@objc(AppDelegateMock)
final class AppDelegateMock: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        removeSessions(application: application)
        return true
    }
}

// MARK: - private methods

private extension AppDelegateMock {
    func removeSessions(application: UIApplication) {
        application.openSessions.forEach {
            application.perform(
                Selector(("_removeSessionFromSessionSet:")),
                with: $0
            )
        }
    }
}

// MARK: - UISceneSession Lifecycle

extension AppDelegateMock {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegateMock.self
        sceneConfiguration.storyboard = nil
        return sceneConfiguration
    }
}
