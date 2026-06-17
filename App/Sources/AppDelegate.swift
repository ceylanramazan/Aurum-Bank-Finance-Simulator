import UIKit
import Core

/// Single entry point of the app. No UIScene lifecycle is used here on purpose —
/// one window, created and owned here, keeps bootstrapping (window → DI → coordinator)
/// in one obvious place instead of split across AppDelegate/SceneDelegate.
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?
    private var dependencyContainer: AppDependencyContainer?
    private var appCoordinator: AppCoordinator?

    // MARK: - UIApplicationDelegate

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let dependencyContainer = AppDependencyContainer(environment: .mock)
        self.dependencyContainer = dependencyContainer

        let appCoordinator = AppCoordinator(window: window, dependencyContainer: dependencyContainer)
        self.appCoordinator = appCoordinator
        appCoordinator.start()

        return true
    }
}
