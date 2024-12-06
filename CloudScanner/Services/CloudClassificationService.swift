import Vision
import CoreLocation
import UIKit

class CloudClassificationService {
    private let weatherService: WeatherAPIService
    private let imageProcessor: ImageProcessingService
    
    static let shared = CloudClassificationService()
    
    init(weatherService: WeatherAPIService = WeatherAPIService(),
         imageProcessor: ImageProcessingService = ImageProcessingService()) {
        self.weatherService = weatherService
        self.imageProcessor = imageProcessor
    }
    
    struct CloudAnalysis {
        let type: CloudType
        let confidence: Double
        let coverage: Int
        let altitude: AltitudeRange
        let weatherImplications: String
        let precipitation: PrecipitationProbability
        
        enum CloudType: String {
            case cumulus = "Cumulus"
            case stratus = "Stratus"
            case cirrus = "Cirrus"
            case cumulonimbus = "Cumulonimbus"
            case altostratus = "Altostratus"
            case nimbostratus = "Nimbostratus"
            case stratocumulus = "Stratocumulus"
            case altocumulus = "Altocumulus"
            case cirrostratus = "Cirrostratus"
            case cirrocumulus = "Cirrocumulus"
        }
        
        enum AltitudeRange: String {
            case low = "Low-level (0-2km)"
            case middle = "Mid-level (2-7km)"
            case high = "High-level (5-13km)"
        }
        
        enum PrecipitationProbability: String {
            case none = "No precipitation expected"
            case low = "Light precipitation possible"
            case medium = "Moderate precipitation likely"
            case high = "Heavy precipitation expected"
        }
    }
    
    func processAndAnalyzeCloud(image: UIImage, location: CLLocation) async throws -> CloudAnalysis {
        // 1. Enhance image for better cloud detection
        let processedImage = try await imageProcessor.enhanceCloudVisibility(in: image)
        
        // 2. Get weather data
        async let weatherData = weatherService.getCurrentWeather(at: location)
        
        // 3. Analyze image
        async let imageAnalysis = analyzeImage(processedImage)
        
        // 4. Wait for both results
        let (weather, analysis) = try await (weatherData, imageAnalysis)
        
        // 5. Determine cloud type using both data points
        return try await determineCloudType(
            imageFeatures: analysis,
            weatherData: weather
        )
    }
    
    private func analyzeImage(_ image: UIImage) async throws -> VNFeaturePrintObservation {
        guard let cgImage = image.cgImage else {
            throw ClassificationError.invalidImage
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNGenerateImageFeaturePrintRequest()
        try requestHandler.perform([request])
        
        guard let result = request.results?.first as? VNFeaturePrintObservation else {
            throw ClassificationError.analysisFailure
        }
        
        return result
    }
    
    private func determineCloudType(
        imageFeatures: VNFeaturePrintObservation,
        weatherData: WeatherAPIService.WeatherData
    ) async throws -> CloudAnalysis {
        // Logic to determine cloud type based on:
        // - Cloud coverage percentage
        // - Temperature
        // - Humidity
        // - Pressure
        // - Visual characteristics
        
        // This is where we'll implement the cloud classification logic
        // For now, return a placeholder
        return CloudAnalysis(
            type: .cumulus,
            confidence: 0.85,
            coverage: weatherData.clouds.all,
            altitude: .low,
            weatherImplications: "Fair weather conditions",
            precipitation: .none
        )
    }
    
    enum ClassificationError: Error {
        case invalidImage
        case analysisFailure
        case insufficientData
    }
} 