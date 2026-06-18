import UIKit
import Core
import BankingDomain

/// Owns the Accounts flow's navigation. Right now this is the very first screen the app
/// shows, so `start()` replaces the root of the shared navigation controller instead of
/// pushing on top of something — there's nothing to push onto yet.
public final class AccountsCoordinator: BaseCoordinator {

    // MARK: - Dependencies

    private let bankingService: BankingService

    // MARK: - Init

    public init(navigationController: UINavigationController, bankingService: BankingService) {
        self.bankingService = bankingService
        super.init(navigationController: navigationController)
    }

    // MARK: - Coordinator

    public override func start() {
        let viewModel = AccountsViewModel(bankingService: bankingService)
        let viewController = AccountsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
