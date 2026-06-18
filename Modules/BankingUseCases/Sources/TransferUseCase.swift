import Foundation
import BankingDomain

/// The only thing a ViewModel calls to move money. Keeps `BankingService` — and the
/// idempotency/audit cross-cutting concerns below — out of the presentation layer.
/// `Sendable` because it only holds `Sendable` protocol existentials, so it can be safely
/// constructed off the main actor and handed to a `@MainActor` ViewModel.
public struct TransferUseCase: Sendable {

    // MARK: - Dependencies

    private let bankingService: BankingService
    private let idempotencyStore: IdempotencyStore
    private let auditLogger: AuditLogger

    // MARK: - Init

    public init(
        bankingService: BankingService,
        idempotencyStore: IdempotencyStore,
        auditLogger: AuditLogger
    ) {
        self.bankingService = bankingService
        self.idempotencyStore = idempotencyStore
        self.auditLogger = auditLogger
    }

    // MARK: - Execution

    /// `idempotencyKey` should be generated once per logical attempt by the caller (e.g. once
    /// per button tap) and reused if that same attempt is retried. A repeat key is silently
    /// ignored — the transfer already happened, so this call is a no-op rather than an error.
    public func execute(from: UUID, to: UUID, amount: Decimal, idempotencyKey: String) async throws {
        let isFirstUse = await idempotencyStore.markIfFirstUse(idempotencyKey)
        guard isFirstUse else {
            return
        }

        do {
            try await bankingService.transfer(from: from, to: to, amount: amount, description: nil)
            await auditLogger.log(action: "transfer.success", metadata: auditMetadata(from: from, to: to, amount: amount, idempotencyKey: idempotencyKey))
        } catch {
            var metadata = auditMetadata(from: from, to: to, amount: amount, idempotencyKey: idempotencyKey)
            metadata["error"] = String(describing: error)
            await auditLogger.log(action: "transfer.failure", metadata: metadata)
            throw error
        }
    }

    // MARK: - Private

    private func auditMetadata(from: UUID, to: UUID, amount: Decimal, idempotencyKey: String) -> [String: String] {
        [
            "from": from.uuidString,
            "to": to.uuidString,
            "amount": "\(amount)",
            "idempotencyKey": idempotencyKey,
        ]
    }
}
