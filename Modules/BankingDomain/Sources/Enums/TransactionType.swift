/// What kind of ledger movement a `Transaction` represents.
public enum TransactionType: Sendable {
    case transfer
    case deposit
    case withdrawal
}
