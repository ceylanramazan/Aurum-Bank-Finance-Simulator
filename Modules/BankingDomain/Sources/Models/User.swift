import Foundation

/// A bank customer — either a private individual or a corporate entity.
public struct User: Identifiable, Sendable {

    // MARK: - Properties

    public let id: UUID
    public let name: String
    public let type: UserType

    // MARK: - Init

    public init(id: UUID = UUID(), name: String, type: UserType) {
        self.id = id
        self.name = name
        self.type = type
    }
}
