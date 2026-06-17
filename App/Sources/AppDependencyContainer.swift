import Foundation
import Core

/// Composition root: the one place allowed to import every module and wire concrete
/// service implementations together. Feature modules receive dependencies through
/// their coordinator's init — they never reach back into this container directly.
final class AppDependencyContainer {

    // MARK: - Properties

    let environment: Environment

    // MARK: - Init

    init(environment: Environment) {
        self.environment = environment
    }

    // MARK: - Service Factories
    // Each factory below will return a concrete, protocol-typed service once
    // Network / Storage / Security expose their implementations.

    func makeNetworkService() {
        // TODO: wire up the NetworkServiceProtocol implementation for `environment`.
    }

    func makeStorageService() {
        // TODO: wire up the StorageServiceProtocol implementation.
    }

    func makeSecurityService() {
        // TODO: wire up the SecurityServiceProtocol implementation.
    }
}
