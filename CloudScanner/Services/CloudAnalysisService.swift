import UIKit
import CoreML
import Vision

@MainActor
class CloudAnalysisService: ObservableObject {
    static let shared = {
        do {
            let instance = try CloudAnalysisService()
            return instance
        } catch {
            fatalError("Failed to initialize CloudAnalysisService: \(error)")
        }
    }()
    
    @Published private(set) var currentAnalysis: CloudAnalysis?
    
    struct CloudAnalysis {
        let cloudType: CloudType
        let confidence: Double
        let weatherConditions: WeatherConditions
        let recommendations: [PhotoRecommendation]
        
        struct PhotoRecommendation: Identifiable {
            let id = UUID()
            let title: String
            let description: String
            let icon: String
        }
    }
    
    private let model: VNCoreMLModel
    private let weatherService: WeatherService
    
    private init() throws {
        self.weatherService = WeatherService.shared
        let config = MLModelConfiguration()
        let cloudClassifier = try CloudClassifier(configuration: config)
        self.model = try VNCoreMLModel(for: cloudClassifier.model)
    }
    
    func analyzeImage(_ image: UIImage) async throws -> CloudAnalysis {
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "CloudAnalysisService", code: -1, 
                         userInfo: [NSLocalizedDescriptionKey: "Failed to get CGImage"])
        }
        
        let request = VNCoreMLRequest(model: model)
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            throw NSError(domain: "CloudAnalysisService", code: -2, 
                         userInfo: [NSLocalizedDescriptionKey: "No classification results"])
        }
        
        let cloudType = try classifyCloud(from: topResult.identifier)
        let weatherConditions = try await analyzeWeatherConditions(for: image)
        let recommendations = generateRecommendations(for: weatherConditions)
        
        let analysis = CloudAnalysis(
            cloudType: cloudType,
            confidence: Double(topResult.confidence),
            weatherConditions: weatherConditions,
            recommendations: recommendations
        )
        
        currentAnalysis = analysis
        return analysis
    }
    
    private func classifyCloud(from identifier: String) throws -> CloudType {
        guard let cloudType = CloudType(rawValue: identifier.lowercased()) else {
            throw NSError(domain: "CloudAnalysisService", code: -3, 
                         userInfo: [NSLocalizedDescriptionKey: "Unknown cloud type"])
        }
        return cloudType
    }
    
    private func analyzeWeatherConditions(for image: UIImage) async throws -> WeatherConditions {
        // For now, return mock data
        return WeatherConditions(
            visibility: 10000,
            sunAngle: 45,
            contrast: 0.8,
            lightQuality: .golden
        )
    }
    
    private func generateRecommendations(for conditions: WeatherConditions) -> [CloudAnalysis.PhotoRecommendation] {
        var recommendations: [CloudAnalysis.PhotoRecommendation] = []
        
        if conditions.isIdealForPhotography {
            recommendations.append(CloudAnalysis.PhotoRecommendation(
                title: "Perfect Conditions",
                description: "Current conditions are ideal for cloud photography",
                icon: "camera.fill"
            ))
        }
        
        if conditions.lightQuality == .golden {
            recommendations.append(CloudAnalysis.PhotoRecommendation(
                title: "Golden Hour",
                description: "Take advantage of the warm, soft lighting",
                icon: "sun.max.fill"
            ))
        }
        
        return recommendations
    }
} 