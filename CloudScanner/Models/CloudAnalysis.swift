import Foundation

struct CloudAnalysis: Identifiable, Codable {
    let id: UUID
    let cloudType: CloudType
    let confidence: Double
    let timestamp: Date
    let weatherConditions: WeatherConditions?
    let location: Location?
    
    enum CloudType: String, Codable {
        case cumulus
        case stratus
        case cirrus
        case nimbus
        case altostratus
        case cumulonimbus
        case unknown
    }
    
    struct WeatherConditions: Codable {
        let temperature: Double
        let humidity: Double
        let pressure: Double
        let windSpeed: Double
    }
    
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
        let altitude: Double?
    }
} 