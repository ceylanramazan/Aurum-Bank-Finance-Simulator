import Foundation

/// A bank account owned by a `User`.
/// `balance` is read-only from outside this module — only `MockBankingService` mutates it,
/// and only after `transfer` has already validated the operation.
public struct Account: Identifiable, Sendable {

    // MARK: - Properties

    public let id: UUID
    public let userId: UUID
    public let iban: String
    public private(set) var balance: Decimal

    // MARK: - Init

    public init(id: UUID = UUID(), userId: UUID, iban: String, balance: Decimal) {
        self.id = id
        self.userId = userId
        self.iban = iban
        self.balance = balance
    }

    // MARK: - Internal Mutation

    mutating func apply(_ delta: Decimal) {
        balance += delta
    }
}
