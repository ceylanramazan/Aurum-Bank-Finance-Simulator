import Foundation

/// `BankingService` implementation that delegates all persistence to injected stores.
///
/// `users` stays a plain in-memory array (no `UserStore` was asked for, and nothing mutates
/// it). `accounts`/`transactions` go through `AccountStore`/`TransactionStore` instead of
/// this actor's own state — see `AccountStore.transferBalance` for why the actual balance
/// mutation has to be one atomic call into the store rather than separate fetch + update
/// calls made from here.
public actor MockBankingService: BankingService {

    // MARK: - Dependencies

    private let users: [User]
    private let accountStore: AccountStore
    private let transactionStore: TransactionStore

    // MARK: - Init

    public init(users: [User], accountStore: AccountStore, transactionStore: TransactionStore) {
        self.users = users
        self.accountStore = accountStore
        self.transactionStore = transactionStore
    }

    // MARK: - BankingService — Queries

    public func getUsers() -> [User] {
        users
    }

    public func getAccounts(for userId: UUID) async -> [Account] {
        await accountStore.fetchAccounts(for: userId)
    }

    public func getTransactions(for accountId: UUID) async -> [Transaction] {
        await transactionStore.fetchTransactions(for: accountId)
    }

    // MARK: - BankingService — Transfer

    public func transfer(
        from: UUID,
        to: UUID,
        amount: Decimal,
        description: String? = nil
    ) async throws {
        // Stateless checks first — fail fast before paying for an actor hop to the store.
        guard amount > 0 else {
            throw BankingError.invalidAmount
        }
        guard from != to else {
            throw BankingError.sameAccountTransfer
        }

        // Single atomic call: validates both accounts exist and the sender has sufficient
        // funds, then mutates both balances, all without a suspension point in between.
        try await accountStore.transferBalance(from: from, to: to, amount: amount)

        await transactionStore.save(
            Transaction(
                fromAccountId: from,
                toAccountId: to,
                amount: amount,
                type: .transfer,
                description: description
            )
        )
    }
}
