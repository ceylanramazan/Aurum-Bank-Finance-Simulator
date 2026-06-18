import Foundation

/// A bank account owned by a `User`.
/// `balance` has no public setter — a new balance means a new `Account` value (see
/// `AccountStore.transferBalance`), there's no in-place mutation to bypass.
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
}
