import Foundation

/// Errors raised by `BankingService` implementations for invalid banking operations.
public enum BankingError: Error, Sendable {
    case insufficientFunds
    case accountNotFound
    case sameAccountTransfer
    case invalidAmount
}

extension BankingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .insufficientFunds:
            return "The sending account does not have enough balance to complete this transfer."
        case .accountNotFound:
            return "One of the accounts in this operation does not exist."
        case .sameAccountTransfer:
            return "You cannot transfer money to the same account."
        case .invalidAmount:
            return "The transfer amount must be greater than zero."
        }
    }
}
