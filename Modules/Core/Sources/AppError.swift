import Foundation

/// Centralized error type surfaced by ViewModels to the presentation layer.
/// Network/Storage/Security layers map their own errors into this type at the
/// module boundary so the UI only ever has one error shape to render.
public enum AppError: Error {
    case network(String)
    case decoding(String)
    case unauthorized
    case validation(String)
    case unknown(String)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network(let message):
            return message
        case .decoding(let message):
            return message
        case .unauthorized:
            return "You are not authorized to perform this action."
        case .validation(let message):
            return message
        case .unknown(let message):
            return message
        }
    }
}
