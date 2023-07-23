import Combine
import StoreKit
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIAppearanceProtocol {
    var window: UIWindow?

    private var cancellables = Set<AnyCancellable>()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        configureAppearance()

        UserDefaults.migrate(to: .shared, from: .standard)
        CoreDataManager.shared.migrate()

        window = .init(windowScene: windowScene)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()

        transitionURLScheme(url: connectionOptions.urlContexts.first?.url)

        DataHolder.$isShowAppReview
            .debounce(for: 1.2, scheduler: DispatchQueue.main)
            .filter { $0 }
            .sink { _ in
                if let windowScene = UIApplication.shared.connectedScenes.first(where: {
                    $0.activationState == .foregroundActive
                }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: windowScene)
                }

                DataHolder.isShowAppReview = false
            }
            .store(in: &cancellables)

        DataHolder.$colorTheme.sink { [weak self] colorScheme in
            switch colorScheme {
            case .system:
                self?.window?.overrideUserInterfaceStyle = .unspecified

            case .light:
                self?.window?.overrideUserInterfaceStyle = .light

            case .dark:
                self?.window?.overrideUserInterfaceStyle = .dark
            }
        }
        .store(in: &cancellables)
    }

    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        transitionURLScheme(url: URLContexts.first?.url)
    }
}

// MARK: - private methods

private extension SceneDelegate {
    func transitionURLScheme(url: URL?) {
        guard
            let url,
            let host = url.host,
            let appURLScheme = AppURLScheme(rawValue: host)
        else {
            return
        }

        (window?.rootViewController as? TabBarController)?.transitionURLScheme(
            appURLScheme,
            url: url
        )
    }
}
