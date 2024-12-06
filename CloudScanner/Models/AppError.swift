import Foundation

enum AppError: Error, LocalizedError {
    case unauthorized
    case processingInProgress
    case cloudServiceError(String)
    case locationNotAvailable
    case weatherServiceError(String)
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Please sign in to continue"
        case .processingInProgress:
            return "Please wait for the current action to complete"
        case .cloudServiceError(let message):
            return "Cloud service error: \(message)"
        case .locationNotAvailable:
            return "Location services are not available"
        case .weatherServiceError(let message):
            return "Weather service error: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .unauthorized:
            return "Sign in to access all features"
        case .processingInProgress:
            return "Try again in a moment"
        case .cloudServiceError:
            return "Please try again later"
        case .locationNotAvailable:
            return "Enable location services in Settings to use this feature"
        case .weatherServiceError:
            return "Check your internet connection and try again"
        }
    }
} 