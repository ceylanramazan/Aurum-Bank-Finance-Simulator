import UIKit

/// Contract for any screen-flow coordinator in the app.
/// Coordinators own navigation; ViewModels and ViewControllers never push/present directly.
public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }

    func start()
}
