import UIKit
import Core

/// Root coordinator: owns the app window and starts the first navigation flow.
/// Until the first feature module exists, it shows a bare placeholder root screen.
final class AppCoordinator: Coordinator {

    // MARK: - Coordinator

    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    // MARK: - Properties

    private let window: UIWindow
    private let dependencyContainer: AppDependencyContainer

    // MARK: - Init

    init(window: UIWindow, dependencyContainer: AppDependencyContainer) {
        self.window = window
        self.dependencyContainer = dependencyContainer
        self.navigationController = UINavigationController()
    }

    // MARK: - Coordinator

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showRootPlaceholder()
    }

    // MARK: - Private

    private func showRootPlaceholder() {
        let placeholder = UIViewController()
        placeholder.view.backgroundColor = .systemBackground
        navigationController.setViewControllers([placeholder], animated: false)
    }
}
