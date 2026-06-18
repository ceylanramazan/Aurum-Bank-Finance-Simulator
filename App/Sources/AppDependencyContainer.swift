import Foundation
import Core
import BankingDomain
import Storage
import BankingUseCases

/// Composition root: the one place allowed to import every module and wire concrete
/// service implementations together. Feature modules receive dependencies through
/// their coordinator's init — they never reach back into this container directly.
final class AppDependencyContainer {

    // MARK: - Properties

    let environment: Environment

    /// Every store/service below is created once here and reused for the app's lifetime.
    /// All of them are actors holding in-memory state — a fresh instance per call would
    /// silently reset balances, wipe transaction/audit history, and forget idempotency keys
    /// on every request.
    private let accountStore: AccountStore
    private let transactionStore: TransactionStore
    private let bankingService: BankingService
    private let auditLogger: AuditLogger
    private let idempotencyStore: IdempotencyStore

    // MARK: - Init

    init(environment: Environment) {
        self.environment = environment

        let seed = BankingSeedDataFactory.makeDefault()
        let accountStore = InMemoryAccountStore(seedAccounts: seed.accounts)
        let transactionStore = InMemoryTransactionStore(seedTransactions: seed.transactions)

        self.accountStore = accountStore
        self.transactionStore = transactionStore
        self.bankingService = MockBankingService(
            users: seed.users,
            accountStore: accountStore,
            transactionStore: transactionStore
        )
        self.auditLogger = InMemoryAuditLogger()
        self.idempotencyStore = InMemoryIdempotencyStore()
    }

    // MARK: - Domain Service Factories

    func makeBankingService() -> BankingService {
        bankingService
    }

    // MARK: - Use Case Factories

    func makeTransferUseCase() -> TransferUseCase {
        TransferUseCase(
            bankingService: bankingService,
            idempotencyStore: idempotencyStore,
            auditLogger: auditLogger
        )
    }

    // MARK: - Remaining Service Factories
    // Each factory below will return a concrete, protocol-typed service once
    // Network / Security expose their implementations.

    func makeNetworkService() {
        // TODO: wire up the NetworkServiceProtocol implementation for `environment`.
    }

    func makeSecurityService() {
        // TODO: wire up the SecurityServiceProtocol implementation.
    }
}
