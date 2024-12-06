import Foundation

@MainActor
class ErrorRecoveryService {
    static let shared = ErrorRecoveryService()
    
    private let maxRetries = 3
    private var retryDelays: [TimeInterval] = [1, 3, 5] // Increasing delays in seconds
    private var retryAttempts: [String: Int] = [:] // Track attempts per operation
    
    private init() {}
    
    func executeWithRetry<T>(
        operation: String,
        maxAttempts: Int = 3,
        action: @escaping () async throws -> T
    ) async throws -> T {
        var attempts = retryAttempts[operation] ?? 0
        
        while attempts < maxAttempts {
            do {
                let result = try await action()
                retryAttempts[operation] = 0 // Reset on success
                return result
            } catch {
                attempts += 1
                retryAttempts[operation] = attempts
                
                if attempts >= maxAttempts {
                    throw error
                }
                
                // Wait before retrying
                try await Task.sleep(until: .now + .seconds(retryDelays[attempts - 1]), clock: .continuous)
            }
        }
        
        throw ProfileError.maxRetriesExceeded
    }
    
    enum ProfileError: LocalizedError {
        case maxRetriesExceeded
        
        var errorDescription: String? {
            switch self {
            case .maxRetriesExceeded:
                return "Operation failed after multiple attempts. Please try again later."
            }
        }
    }
} 