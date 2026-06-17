import Combine

/// Base class every feature ViewModel inherits from.
/// Holds the shared `Set<AnyCancellable>` so subclasses don't repeat Combine bookkeeping.
open class BaseViewModel {

    // MARK: - Properties

    public var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init() {}
}
