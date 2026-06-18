import Foundation
import Combine
import Core
import BankingUseCases

/// Presentation-layer wrapper around `TransferUseCase`. `@MainActor` guarantees every
/// `@Published` mutation — and therefore every SwiftUI/UIKit-Combine update it drives —
/// happens on the main thread, while the actual transfer still runs through the use case's
/// actor-isolated path underneath.
@MainActor
public final class BankingViewModel: BaseViewModel, ObservableObject {

    // MARK: - Published State

    @Published public private(set) var isLoading = false
    @Published public private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let transferUseCase: TransferUseCase

    // MARK: - Init

    public init(transferUseCase: TransferUseCase) {
        self.transferUseCase = transferUseCase
        super.init()
    }

    // MARK: - Intents

    public func transfer(from: UUID, to: UUID, amount: Decimal) {
        guard !isLoading else { return } // ignore taps while a transfer is already in flight
        errorMessage = nil
        isLoading = true

        // A fresh key per tap: this call is a new logical attempt, not a retry of a
        // previous one, so it must not be deduplicated against anything earlier.
        let idempotencyKey = UUID().uuidString

        Task {
            defer { isLoading = false }
            do {
                try await transferUseCase.execute(from: from, to: to, amount: amount, idempotencyKey: idempotencyKey)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
