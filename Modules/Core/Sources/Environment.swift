/// Runtime configuration the app is currently running under.
/// Injected once at launch and threaded through `AppDependencyContainer`.
public enum Environment {
    case mock
    case staging
    case production
}

extension Environment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .mock:
            return "Mock"
        case .staging:
            return "Staging"
        case .production:
            return "Production"
        }
    }
}
