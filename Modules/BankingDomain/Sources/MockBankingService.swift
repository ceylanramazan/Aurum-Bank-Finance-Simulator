import Foundation

/// In-memory `BankingService` used for local simulation/demo purposes.
///
/// Implemented as an `actor` so every read and the transfer's read-validate-mutate sequence
/// are serialized automatically by the Swift runtime — no manual locking, no data races on
/// `users` / `accounts` / `transactions`, even under concurrent callers.
public actor MockBankingService: BankingService {

    // MARK: - Storage

    private var users: [User]
    private var accounts: [Account]
    private var transactions: [Transaction]

    // MARK: - Init

    public init() {
        let seed = Self.makeSeedData()
        self.users = seed.users
        self.accounts = seed.accounts
        self.transactions = seed.transactions
    }

    // MARK: - BankingService — Queries

    public func getUsers() -> [User] {
        users
    }

    public func getAccounts(for userId: UUID) -> [Account] {
        accounts.filter { $0.userId == userId }
    }

    public func getTransactions(for accountId: UUID) -> [Transaction] {
        transactions
            .filter { $0.fromAccountId == accountId || $0.toAccountId == accountId }
            .sorted { $0.date > $1.date }
    }

    // MARK: - BankingService — Transfer

    public func transfer(
        from: UUID,
        to: UUID,
        amount: Decimal,
        description: String? = nil
    ) throws {
        guard amount > 0 else {
            throw BankingError.invalidAmount
        }
        guard from != to else {
            throw BankingError.sameAccountTransfer
        }
        guard let fromIndex = accounts.firstIndex(where: { $0.id == from }) else {
            throw BankingError.accountNotFound
        }
        guard let toIndex = accounts.firstIndex(where: { $0.id == to }) else {
            throw BankingError.accountNotFound
        }
        guard accounts[fromIndex].balance >= amount else {
            throw BankingError.insufficientFunds
        }

        accounts[fromIndex].apply(-amount)
        accounts[toIndex].apply(amount)

        transactions.append(
            Transaction(
                fromAccountId: from,
                toAccountId: to,
                amount: amount,
                type: .transfer,
                description: description
            )
        )
    }

    // MARK: - Seed Data

    private static func makeSeedData() -> (users: [User], accounts: [Account], transactions: [Transaction]) {
        let alice = User(name: "Alice Yılmaz", type: .individual)
        let acme = User(name: "Acme Corporation", type: .corporate)

        let aliceChecking = Account(userId: alice.id, iban: "TR330006100519786457841326", balance: 5_000)
        let aliceSavings = Account(userId: alice.id, iban: "TR330006100519786457841327", balance: 12_500)
        let acmeOperating = Account(userId: acme.id, iban: "TR330006100519786457841328", balance: 250_000)
        let acmePayroll = Account(userId: acme.id, iban: "TR330006100519786457841329", balance: 80_000)

        let dayAgo = Date(timeIntervalSinceNow: -86_400)
        let weekAgo = Date(timeIntervalSinceNow: -7 * 86_400)

        let transactions = [
            Transaction(
                fromAccountId: aliceChecking.id,
                toAccountId: aliceSavings.id,
                amount: 500,
                type: .transfer,
                date: dayAgo,
                description: "Move to savings"
            ),
            Transaction(
                fromAccountId: acmeOperating.id,
                toAccountId: acmePayroll.id,
                amount: 15_000,
                type: .transfer,
                date: weekAgo,
                description: "Monthly payroll funding"
            ),
            Transaction(
                fromAccountId: aliceChecking.id,
                toAccountId: acmeOperating.id,
                amount: 250,
                type: .transfer,
                date: weekAgo,
                description: "Invoice payment"
            ),
        ]

        return (
            users: [alice, acme],
            accounts: [aliceChecking, aliceSavings, acmeOperating, acmePayroll],
            transactions: transactions
        )
    }
}
