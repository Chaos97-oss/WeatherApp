import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let splashVC = SplashViewController()
        let navController = UINavigationController(rootViewController: splashVC)
        navController.navigationBar.isHidden = true
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
