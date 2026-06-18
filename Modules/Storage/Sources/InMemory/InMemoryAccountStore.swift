import Foundation
import BankingDomain

/// In-memory `AccountStore`. An `actor` so every read/write — including the compound
/// `transferBalance` step — is serialized with no manual locking.
public actor InMemoryAccountStore: AccountStore {

    // MARK: - State

    private var accountsById: [UUID: Account]

    // MARK: - Init

    public init(seedAccounts: [Account] = []) {
        self.accountsById = Dictionary(uniqueKeysWithValues: seedAccounts.map { ($0.id, $0) })
    }

    // MARK: - AccountStore

    public func fetchAccount(by id: UUID) -> Account? {
        accountsById[id]
    }

    public func fetchAccounts(for userId: UUID) -> [Account] {
        accountsById.values.filter { $0.userId == userId }
    }

    public func updateBalance(accountId: UUID, newBalance: Decimal) throws {
        guard let account = accountsById[accountId] else {
            throw BankingError.accountNotFound
        }
        accountsById[accountId] = Account(
            id: account.id,
            userId: account.userId,
            iban: account.iban,
            balance: newBalance
        )
    }

    public func transferBalance(from: UUID, to: UUID, amount: Decimal) throws {
        guard let fromAccount = accountsById[from] else {
            throw BankingError.accountNotFound
        }
        guard let toAccount = accountsById[to] else {
            throw BankingError.accountNotFound
        }
        guard fromAccount.balance >= amount else {
            throw BankingError.insufficientFunds
        }

        accountsById[from] = Account(
            id: fromAccount.id,
            userId: fromAccount.userId,
            iban: fromAccount.iban,
            balance: fromAccount.balance - amount
        )
        accountsById[to] = Account(
            id: toAccount.id,
            userId: toAccount.userId,
            iban: toAccount.iban,
            balance: toAccount.balance + amount
        )
    }
}
