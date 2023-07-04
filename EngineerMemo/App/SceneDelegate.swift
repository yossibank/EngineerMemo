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

        window = .init(windowScene: windowScene)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()

        DataHolder.$isShowAppReview
            .debounce(for: 1.2, scheduler: DispatchQueue.main)
            .filter { $0 }
            .sink { _ in
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
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
}
