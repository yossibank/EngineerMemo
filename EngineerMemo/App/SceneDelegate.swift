import Combine
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
