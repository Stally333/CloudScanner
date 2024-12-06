import CoreML
import Vision
import UIKit

class CloudClassifier {
    let model: MLModel
    private let configuration: MLModelConfiguration
    
    init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        self.configuration = configuration
        
        // Load model
        guard let modelURL = Bundle.main.url(forResource: "CloudNet", withExtension: "mlmodelc"),
              let cloudNet = try? MLModel(contentsOf: modelURL, configuration: configuration) else {
            throw MLError.modelNotFound
        }
        
        self.model = cloudNet
    }
    
    enum MLError: LocalizedError {
        case modelNotFound
        case predictionFailed
        case invalidInput
        
        var errorDescription: String? {
            switch self {
            case .modelNotFound: return "ML model not found"
            case .predictionFailed: return "Failed to make prediction"
            case .invalidInput: return "Invalid input for prediction"
            }
        }
    }
} 