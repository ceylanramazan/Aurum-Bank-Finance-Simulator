import Foundation
import BankingDomain

/// In-memory `TransactionStore`. An `actor` so concurrent `save`/`fetchTransactions` calls
/// never race on the underlying array.
public actor InMemoryTransactionStore: TransactionStore {

    // MARK: - State

    private var transactions: [Transaction]

    // MARK: - Init

    public init(seedTransactions: [Transaction] = []) {
        self.transactions = seedTransactions
    }

    // MARK: - TransactionStore

    public func save(_ transaction: Transaction) {
        transactions.append(transaction)
    }

    public func fetchTransactions(for accountId: UUID) -> [Transaction] {
        transactions
            .filter { $0.fromAccountId == accountId || $0.toAccountId == accountId }
            .sorted { $0.date > $1.date }
    }
}
