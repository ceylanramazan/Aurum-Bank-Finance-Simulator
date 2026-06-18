import Foundation

/// Fixture data shared by `MockBankingService` consumers. Moved out of `MockBankingService`
/// itself now that it no longer owns storage directly — whoever constructs the stores
/// (the app's composition root) seeds them with this.
public struct BankingSeedData: Sendable {
    public let users: [User]
    public let accounts: [Account]
    public let transactions: [Transaction]
}

public enum BankingSeedDataFactory {
    public static func makeDefault() -> BankingSeedData {
        let alice = User(name: "Alice Yılmaz", type: .individual)
        let acme = User(name: "Acme Corporation", type: .corporate)

        let aliceChecking = Account(userId: alice.id, iban: "TR330006100519786457841326", balance: 5_000)
        let aliceSavings = Account(userId: alice.id, iban: "TR330006100519786457841327", balance: 12_500)
        let acmeOperating = Account(userId: acme.id, iban: "TR330006100519786457841328", balance: 250_000)
        let acmePayroll = Account(userId: acme.id, iban: "TR330006100519786457841329", balance: 80_000)

        let dayAgo = Date(timeIntervalSinceNow: -86_400)
        let weekAgo = Date(timeIntervalSinceNow: -7 * 86_400)

        let transactions = [
            Transaction(
                fromAccountId: aliceChecking.id,
                toAccountId: aliceSavings.id,
                amount: 500,
                type: .transfer,
                date: dayAgo,
                description: "Move to savings"
            ),
            Transaction(
                fromAccountId: acmeOperating.id,
                toAccountId: acmePayroll.id,
                amount: 15_000,
                type: .transfer,
                date: weekAgo,
                description: "Monthly payroll funding"
            ),
            Transaction(
                fromAccountId: aliceChecking.id,
                toAccountId: acmeOperating.id,
                amount: 250,
                type: .transfer,
                date: weekAgo,
                description: "Invoice payment"
            ),
        ]

        return BankingSeedData(
            users: [alice, acme],
            accounts: [aliceChecking, aliceSavings, acmeOperating, acmePayroll],
            transactions: transactions
        )
    }
}
