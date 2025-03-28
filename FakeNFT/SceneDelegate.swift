import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var appCoordinator = AppCoordinator(
        navigationController: UINavigationController()
    )

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        appCoordinator.start()

        window = UIWindow(windowScene: scene)
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
    }
}
