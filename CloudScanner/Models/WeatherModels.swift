import Foundation
import CoreLocation
import SwiftUI

// MARK: - Weather Service Models
extension WeatherService {
    struct WeatherData: Identifiable {
        let id: UUID
        let temperature: Double
        let humidity: Double
        let pressure: Double
        let windSpeed: Double
        let windDirection: Double
        let cloudCover: Int
        let visibility: Double
        let conditions: [String]
        let timestamp: Date
        let location: CLLocation
        
        // Photography-related computed properties
        var isGoldenHour: Bool {
            let hour = Calendar.current.component(.hour, from: timestamp)
            return hour >= 6 && hour <= 8 || hour >= 17 && hour <= 19
        }
        
        var isBlueMoment: Bool {
            let hour = Calendar.current.component(.hour, from: timestamp)
            return hour >= 5 && hour < 6 || hour > 19 && hour <= 20
        }
        
        var photographyScore: Int {
            var score = 0
            if visibility > 8000 { score += 20 }
            if cloudCover > 20 && cloudCover < 80 { score += 30 }
            if isGoldenHour { score += 30 }
            if isBlueMoment { score += 20 }
            return score
        }
    }
    
    struct ForecastData: Identifiable {
        let id: UUID
        let time: Date
        let temperature: Double
        let cloudCover: Double
        let symbolName: String
    }
}

// MARK: - Cloud Types
enum CloudType: String, Identifiable, CaseIterable, Codable {
    case cumulus = "cumulus"
    case stratus = "stratus"
    case cirrus = "cirrus"
    case cumulonimbus = "cumulonimbus"
    case altostratus = "altostratus"
    case nimbostratus = "nimbostratus"
    case stratocumulus = "stratocumulus"
    case altocumulus = "altocumulus"
    case cirrostratus = "cirrostratus"
    case cirrocumulus = "cirrocumulus"
    
    var id: String { rawValue }
    
    var name: String {
        rawValue.capitalized
    }
}

// MARK: - Photography Models
enum LightQuality: String, CaseIterable {
    case harsh = "harsh"
    case soft = "soft"
    case golden = "golden"
    case blue = "blue"
}

struct WeatherConditions {
    let visibility: Double
    let sunAngle: Double
    let contrast: Double
    let lightQuality: LightQuality
    
    var isIdealForPhotography: Bool {
        visibility > 8000 && 
        (lightQuality == .golden || lightQuality == .soft) &&
        contrast > 0.6
    }
}

struct CloudDistributionData: Codable {
    let type: String
    let percentage: Double
    
    init(_ tuple: (String, Double)) {
        self.type = tuple.0
        self.percentage = tuple.1
    }
}

struct CloudConditions: Codable {
    let primaryType: CloudType?
    let description: String
    let coverage: Int
    let altitude: Double
    let visibility: Int
    let quality: CloudQuality
    let distribution: [CloudDistributionData]
    
    static let mock = CloudConditions(
        primaryType: CloudType.cumulus,
        description: "Scattered cumulus clouds with good visibility",
        coverage: 40,
        altitude: 2000,
        visibility: 10000,
        quality: CloudQuality.good,
        distribution: [
            CloudDistributionData(("Cumulus", 0.4)),
            CloudDistributionData(("Stratus", 0.3)),
            CloudDistributionData(("Cirrus", 0.2)),
            CloudDistributionData(("Other", 0.1))
        ]
    )
}

enum CloudQuality: String, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .fair: return .orange
        case .poor: return .red
        }
    }
}

enum TimeRange: String, CaseIterable {
    case day = "24h"
    case week = "7 Days"
    case month = "30 Days"
} 