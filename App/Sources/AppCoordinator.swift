import UIKit
import Core
import Accounts

/// Root coordinator: owns the app window and starts the first navigation flow.
/// Accounts is the first real feature, so it's also the app's initial screen.
@MainActor
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
        showAccounts()
    }

    // MARK: - Private

    private func showAccounts() {
        let accountsCoordinator = AccountsCoordinator(
            navigationController: navigationController,
            bankingService: dependencyContainer.makeBankingService()
        )
        childCoordinators.append(accountsCoordinator)
        accountsCoordinator.start()
    }
}
