import Foundation

/// In-memory `AuditLogger`. An `actor` so concurrent use-case invocations can log
/// simultaneously without corrupting the log array.
public actor InMemoryAuditLogger: AuditLogger {

    // MARK: - State

    private var logs: [AuditLog] = []

    // MARK: - Init

    public init() {}

    // MARK: - AuditLogger

    public func log(action: String, metadata: [String: String]) {
        logs.append(AuditLog(action: action, metadata: metadata))
    }

    public func fetchLogs() -> [AuditLog] {
        logs
    }
}
