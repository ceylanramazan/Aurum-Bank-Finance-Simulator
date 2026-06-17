import Foundation

/// A single ledger entry recording money moving between two accounts.
public struct Transaction: Identifiable, Sendable {

    // MARK: - Properties

    public let id: UUID
    public let fromAccountId: UUID
    public let toAccountId: UUID
    public let amount: Decimal
    public let type: TransactionType
    public let date: Date
    public let description: String?

    // MARK: - Init

    public init(
        id: UUID = UUID(),
        fromAccountId: UUID,
        toAccountId: UUID,
        amount: Decimal,
        type: TransactionType,
        date: Date = Date(),
        description: String? = nil
    ) {
        self.id = id
        self.fromAccountId = fromAccountId
        self.toAccountId = toAccountId
        self.amount = amount
        self.type = type
        self.date = date
        self.description = description
    }
}
