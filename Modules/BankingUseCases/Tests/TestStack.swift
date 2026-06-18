import Foundation
import BankingDomain
import Storage
@testable import BankingUseCases

/// Assembles a fully-wired stack (stores, service, use case) the same way
/// `AppDependencyContainer` does, so tests exercise the real composition, not a shortcut.
struct TestStack {
    let bankingService: MockBankingService
    let useCase: TransferUseCase
    let idempotencyStore: InMemoryIdempotencyStore
    let auditLogger: InMemoryAuditLogger

    static func make() -> TestStack {
        let seed = BankingSeedDataFactory.makeDefault()
        let accountStore = InMemoryAccountStore(seedAccounts: seed.accounts)
        let transactionStore = InMemoryTransactionStore(seedTransactions: seed.transactions)
        let bankingService = MockBankingService(
            users: seed.users,
            accountStore: accountStore,
            transactionStore: transactionStore
        )
        let idempotencyStore = InMemoryIdempotencyStore()
        let auditLogger = InMemoryAuditLogger()
        let useCase = TransferUseCase(
            bankingService: bankingService,
            idempotencyStore: idempotencyStore,
            auditLogger: auditLogger
        )

        return TestStack(
            bankingService: bankingService,
            useCase: useCase,
            idempotencyStore: idempotencyStore,
            auditLogger: auditLogger
        )
    }
}
