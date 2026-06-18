import Foundation
import Core
import BankingDomain
import BankingUseCases

/// Composition root: the one place allowed to import every module and wire concrete
/// service implementations together. Feature modules receive dependencies through
/// their coordinator's init — they never reach back into this container directly.
final class AppDependencyContainer {

    // MARK: - Properties

    let environment: Environment

    /// Created once and reused for the app's lifetime. `MockBankingService` is an actor
    /// holding in-memory state — a fresh instance per call would silently reset every
    /// balance and wipe transaction history on each request.
    private let bankingService: BankingService

    // MARK: - Init

    init(environment: Environment) {
        self.environment = environment
        self.bankingService = MockBankingService()
    }

    // MARK: - Domain Service Factories

    func makeBankingService() -> BankingService {
        bankingService
    }

    // MARK: - Use Case Factories

    func makeTransferUseCase() -> TransferUseCase {
        TransferUseCase(bankingService: bankingService)
    }

    // MARK: - Remaining Service Factories
    // Each factory below will return a concrete, protocol-typed service once
    // Network / Storage / Security expose their implementations.

    func makeNetworkService() {
        // TODO: wire up the NetworkServiceProtocol implementation for `environment`.
    }

    func makeStorageService() {
        // TODO: wire up the StorageServiceProtocol implementation.
    }

    func makeSecurityService() {
        // TODO: wire up the SecurityServiceProtocol implementation.
    }
}
