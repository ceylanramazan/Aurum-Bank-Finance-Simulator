import XCTest
import BankingDomain
import BankingUseCases

/// Proves that routing many concurrent transfers — each with its own idempotency key —
/// through one shared `MockBankingService` instance never corrupts the ledger.
final class TransferUseCaseConcurrencyTests: XCTestCase {

    func test_concurrentTransfersThroughSharedService_neverCorruptBalances() async throws {
        let stack = TestStack.make()

        let users = await stack.bankingService.getUsers()
        let accounts = await stack.bankingService.getAccounts(for: users[1].id) // Acme: 250_000 / 80_000
        let from = try XCTUnwrap(accounts.first)
        let to = try XCTUnwrap(accounts.last)

        let transferCount = 50
        let amount: Decimal = 10

        await withTaskGroup(of: Void.self) { group in
            for i in 0..<transferCount {
                group.addTask {
                    try? await stack.useCase.execute(from: from.id, to: to.id, amount: amount, idempotencyKey: "key-\(i)")
                }
            }
        }

        let updated = await stack.bankingService.getAccounts(for: users[1].id)
        let updatedFrom = try XCTUnwrap(updated.first { $0.id == from.id })
        let updatedTo = try XCTUnwrap(updated.first { $0.id == to.id })

        let expectedMoved = amount * Decimal(transferCount)
        XCTAssertEqual(updatedFrom.balance, from.balance - expectedMoved)
        XCTAssertEqual(updatedTo.balance, to.balance + expectedMoved)

        let transactions = await stack.bankingService.getTransactions(for: from.id)
        XCTAssertEqual(transactions.filter { $0.amount == amount }.count, transferCount)
    }
}
