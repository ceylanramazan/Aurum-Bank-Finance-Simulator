import Foundation

/// Persistence port for `Transaction` records. See `AccountStore` for why this protocol
/// lives in `BankingDomain` rather than `Storage`.
public protocol TransactionStore: Sendable {
    func save(_ transaction: Transaction) async
    func fetchTransactions(for accountId: UUID) async -> [Transaction]
}
