import Foundation

/// A single audit trail entry. Generic on purpose (`action` + free-form `metadata`) so any
/// future use case can log through the same `AuditLogger` without a new model per action.
public struct AuditLog: Sendable, Identifiable {
    public let id: UUID
    public let action: String
    public let timestamp: Date
    public let metadata: [String: String]

    public init(
        id: UUID = UUID(),
        action: String,
        timestamp: Date = Date(),
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.action = action
        self.timestamp = timestamp
        self.metadata = metadata
    }
}
