import Foundation

enum AnalysisError: LocalizedError {
    case invalidImage
    case analysisFailure
    case insufficientLighting
    case poorVisibility
    
    var errorDescription: String? {
        switch self {
        case .invalidImage: return "Unable to process image"
        case .analysisFailure: return "Cloud analysis failed"
        case .insufficientLighting: return "Insufficient lighting for accurate analysis"
        case .poorVisibility: return "Poor visibility conditions"
        }
    }
} 