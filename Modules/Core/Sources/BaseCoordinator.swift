import UIKit

/// Default implementation of child-coordinator bookkeeping shared by every flow coordinator.
/// Concrete coordinators subclass this and override `start()`.
open class BaseCoordinator: Coordinator {

    // MARK: - Coordinator

    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []

    // MARK: - Init

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator

    open func start() {
        assertionFailure("\(Self.self) must override start()")
    }

    // MARK: - Child Management

    public func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
