import Foundation
import CoreGraphics

struct CloudAnalysisResult {
    let cloudType: CloudType
    let confidence: Double
    let weatherData: WeatherData
    let boundingBox: CGRect
    
    enum CloudType: String {
        case cumulus = "Cumulus"
        case stratus = "Stratus"
        case cirrus = "Cirrus"
        case cumulonimbus = "Cumulonimbus"
    }
    
    struct WeatherData {
        let temperature: Double
        let humidity: Double
        let pressure: Double
        let cloudCover: Int
    }
} 