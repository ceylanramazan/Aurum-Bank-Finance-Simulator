import Foundation

/// Tracks which idempotency keys have already been used.
public protocol IdempotencyStore: Sendable {
    /// Atomically checks whether `key` has been seen before and, if not, marks it as seen.
    /// Returns `true` if this call is the first (and only) use of `key` — the caller should
    /// proceed. Returns `false` if `key` was already used — the caller must not repeat the
    /// operation. Must be a single call (not a separate "contains" + "insert") so concurrent
    /// callers racing on the same key can't both see "not used yet" before either marks it.
    func markIfFirstUse(_ key: String) async -> Bool
}
