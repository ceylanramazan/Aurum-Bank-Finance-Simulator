import UIKit

/// Contract for any screen-flow coordinator in the app.
/// Coordinators own navigation; ViewModels and ViewControllers never push/present directly.
/// `@MainActor` because every conformer holds a `UINavigationController` and constructs
/// `@MainActor` ViewModels/ViewControllers — coordinating navigation is inherently a
/// main-thread responsibility, not an incidental one.
@MainActor
public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }

    func start()
}
