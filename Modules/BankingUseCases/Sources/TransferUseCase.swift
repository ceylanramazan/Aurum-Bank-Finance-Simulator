import Foundation
import BankingDomain

/// The only thing a ViewModel calls to move money. Keeps `BankingService` — and any future
/// cross-cutting concerns (logging, analytics, fraud checks) — out of the presentation layer.
/// `Sendable` because it only holds a `Sendable` protocol existential, so it can be safely
/// constructed off the main actor and handed to a `@MainActor` ViewModel.
public struct TransferUseCase: Sendable {

    // MARK: - Dependencies

    private let bankingService: BankingService

    // MARK: - Init

    public init(bankingService: BankingService) {
        self.bankingService = bankingService
    }

    // MARK: - Execution

    public func execute(from: UUID, to: UUID, amount: Decimal) async throws {
        try await bankingService.transfer(from: from, to: to, amount: amount, description: nil)
    }
}
