import Foundation

/// Persistence port for `Account` data. Lives in `BankingDomain` (not `Storage`) on purpose:
/// the protocol's methods return `Account`/throw `BankingError`, both domain types, so if the
/// protocol lived in `Storage` instead, `BankingDomain` would need to import `Storage` for the
/// type and `Storage` would need to import `BankingDomain` for the models — a dependency
/// cycle. Putting the port here and the adapter (`InMemoryAccountStore`) in `Storage` keeps
/// dependencies one-directional: `Storage -> BankingDomain`, never the reverse.
public protocol AccountStore: Sendable {
    func fetchAccount(by id: UUID) async -> Account?
    func fetchAccounts(for userId: UUID) async -> [Account]
    func updateBalance(accountId: UUID, newBalance: Decimal) async throws

    /// Atomically validates and applies a transfer between two accounts in one call.
    /// This must be a single call — not separate fetch + updateBalance calls from the
    /// caller — because crossing into this actor twice would leave a suspension point
    /// between the read and the write, letting two concurrent transfers both observe the
    /// same stale balance and both succeed (a lost-update race). A conforming `actor`
    /// implementation has no `await` inside this method, so the whole check-then-mutate
    /// sequence runs as one uninterruptible step.
    func transferBalance(from: UUID, to: UUID, amount: Decimal) async throws
}
