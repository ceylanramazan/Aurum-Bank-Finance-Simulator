import Foundation
import BankingDomain

/// Loads every account across every seeded user and exposes it to the screen.
/// `@MainActor` because `accounts`/`onUpdate` are read and fired on the UI thread, while
/// `load()` reaches into the actor-isolated `BankingService` underneath.
@MainActor
final class AccountsViewModel {

    // MARK: - State

    private(set) var accounts: [Account] = []
    var onUpdate: (() -> Void)?

    // MARK: - Dependencies

    private let bankingService: BankingService

    // MARK: - Init

    init(bankingService: BankingService) {
        self.bankingService = bankingService
    }

    // MARK: - Loading

    func load() {
        Task {
            // No "current user" concept exists yet (no auth module), so this is every
            // account belonging to every seeded user — a ledger view, not a personal one.
            let users = await bankingService.getUsers()
            var fetchedAccounts: [Account] = []
            for user in users {
                fetchedAccounts += await bankingService.getAccounts(for: user.id)
            }
            accounts = fetchedAccounts
            onUpdate?()
        }
    }
}
