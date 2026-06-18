import Foundation

/// Records what use cases did, for compliance/debugging — never throws, since a failed log
/// write must never block or fail the banking operation it's describing.
public protocol AuditLogger: Sendable {
    func log(action: String, metadata: [String: String]) async
    func fetchLogs() async -> [AuditLog]
}
