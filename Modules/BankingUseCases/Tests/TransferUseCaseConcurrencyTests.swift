import XCTest
import BankingDomain
import BankingUseCases

/// Proves that routing many concurrent transfers through one shared `MockBankingService`
/// instance — exactly how `AppDependencyContainer` shares it app-wide — never corrupts the
/// ledger. The actor serializes every `transfer` call internally, so this needs no manual
/// locking at the use-case layer to be safe.
final class TransferUseCaseConcurrencyTests: XCTestCase {

    func test_concurrentTransfersThroughSharedService_neverCorruptBalances() async throws {
        let bankingService = MockBankingService()
        let useCase = TransferUseCase(bankingService: bankingService)

        let users = await bankingService.getUsers()
        let accounts = await bankingService.getAccounts(for: users[1].id) // Acme: 250_000 / 80_000
        let from = try XCTUnwrap(accounts.first)
        let to = try XCTUnwrap(accounts.last)

        let transferCount = 50
        let amount: Decimal = 10

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<transferCount {
                group.addTask {
                    try? await useCase.execute(from: from.id, to: to.id, amount: amount)
                }
            }
        }

        let updated = await bankingService.getAccounts(for: users[1].id)
        let updatedFrom = try XCTUnwrap(updated.first { $0.id == from.id })
        let updatedTo = try XCTUnwrap(updated.first { $0.id == to.id })

        let expectedMoved = amount * Decimal(transferCount)
        XCTAssertEqual(updatedFrom.balance, from.balance - expectedMoved)
        XCTAssertEqual(updatedTo.balance, to.balance + expectedMoved)

        let transactions = await bankingService.getTransactions(for: from.id)
        XCTAssertEqual(transactions.filter { $0.amount == amount }.count, transferCount)
    }
}
