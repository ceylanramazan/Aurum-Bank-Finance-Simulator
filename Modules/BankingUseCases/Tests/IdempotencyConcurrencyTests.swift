import XCTest
import BankingDomain
import BankingUseCases

/// The idempotency requirement: 50 concurrent calls sharing one idempotency key must result
/// in exactly one applied transfer, no matter how the calls interleave.
final class IdempotencyConcurrencyTests: XCTestCase {

    func test_concurrentTransfersWithSameIdempotencyKey_appliesExactlyOnce() async throws {
        let stack = TestStack.make()

        let users = await stack.bankingService.getUsers()
        let accounts = await stack.bankingService.getAccounts(for: users[1].id) // Acme: 250_000 / 80_000
        let from = try XCTUnwrap(accounts.first)
        let to = try XCTUnwrap(accounts.last)

        let sharedKey = "shared-idempotency-key"
        let amount: Decimal = 1_000
        let callCount = 50

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<callCount {
                group.addTask {
                    try? await stack.useCase.execute(from: from.id, to: to.id, amount: amount, idempotencyKey: sharedKey)
                }
            }
        }

        let updated = await stack.bankingService.getAccounts(for: users[1].id)
        let updatedFrom = try XCTUnwrap(updated.first { $0.id == from.id })
        let updatedTo = try XCTUnwrap(updated.first { $0.id == to.id })

        // Only ONE of the 50 calls should have actually moved money, no matter how they raced.
        XCTAssertEqual(updatedFrom.balance, from.balance - amount)
        XCTAssertEqual(updatedTo.balance, to.balance + amount)

        let transactions = await stack.bankingService.getTransactions(for: from.id)
        XCTAssertEqual(transactions.filter { $0.amount == amount }.count, 1)

        let successLogs = await stack.auditLogger.fetchLogs().filter { $0.action == "transfer.success" }
        XCTAssertEqual(successLogs.count, 1)
    }
}
