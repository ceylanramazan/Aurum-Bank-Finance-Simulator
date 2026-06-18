import Foundation

/// In-memory `IdempotencyStore`. An `actor` so `markIfFirstUse` is atomic — the check and
/// the insert happen in one uninterruptible step, which is what makes the "exactly once"
/// guarantee hold under concurrent callers using the same key.
public actor InMemoryIdempotencyStore: IdempotencyStore {

    // MARK: - State

    private var seenKeys: Set<String> = []

    // MARK: - Init

    public init() {}

    // MARK: - IdempotencyStore

    public func markIfFirstUse(_ key: String) -> Bool {
        guard !seenKeys.contains(key) else {
            return false
        }
        seenKeys.insert(key)
        return true
    }
}
