import Foundation

/// Contract for anything that can answer banking queries and move money between accounts.
/// `MockBankingService` is the only implementation today; a real backend-backed implementation
/// could conform to the same protocol later without changing any caller.
///
/// Methods are `async` so an actor-isolated implementation (see `MockBankingService`) can
/// satisfy this protocol while keeping its mutable state safely isolated.
public protocol BankingService: Sendable {
    func getUsers() async -> [User]
    func getAccounts(for userId: UUID) async -> [Account]
    func getTransactions(for accountId: UUID) async -> [Transaction]

    func transfer(
        from: UUID,
        to: UUID,
        amount: Decimal,
        description: String?
    ) async throws
}
