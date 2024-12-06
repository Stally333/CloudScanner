import Foundation

class WindDataManager {
    static let shared = WindDataManager()
    
    private init() {}
    
    func getWindDescription(speed: Double, direction: Int) -> String {
        let beaufortScale = getBeaufortScale(speed: speed)
        let directionText = getWindDirection(degrees: Double(direction))  // Convert Int to Double
        return "\(beaufortScale.description) (\(Int(speed))m/s) from \(directionText)"
    }
    
    private func getBeaufortScale(speed: Double) -> BeaufortScale {
        let speedInt = Int(round(speed))  // Properly round Double to Int
        switch speedInt {
        case 0...1: return .calm
        case 2...5: return .lightAir
        case 6...11: return .lightBreeze
        case 12...19: return .gentleBreeze
        case 20...28: return .moderateBreeze
        case 29...38: return .freshBreeze
        case 39...49: return .strongBreeze
        case 50...61: return .nearGale
        case 62...74: return .gale
        case 75...88: return .strongGale
        case 89...102: return .storm
        case 103...117: return .violentStorm
        default: return .hurricane
        }
    }
    
    private func getWindDirection(degrees: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                         "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int(round(((degrees.truncatingRemainder(dividingBy: 360)) / 22.5)))
        return directions[index % 16]
    }
    
    enum BeaufortScale {
        case calm, lightAir, lightBreeze, gentleBreeze, moderateBreeze,
             freshBreeze, strongBreeze, nearGale, gale, strongGale,
             storm, violentStorm, hurricane
        
        var description: String {
            switch self {
            case .calm: return "Calm"
            case .lightAir: return "Light Air"
            case .lightBreeze: return "Light Breeze"
            case .gentleBreeze: return "Gentle Breeze"
            case .moderateBreeze: return "Moderate Breeze"
            case .freshBreeze: return "Fresh Breeze"
            case .strongBreeze: return "Strong Breeze"
            case .nearGale: return "Near Gale"
            case .gale: return "Gale"
            case .strongGale: return "Strong Gale"
            case .storm: return "Storm"
            case .violentStorm: return "Violent Storm"
            case .hurricane: return "Hurricane"
            }
        }
    }
} 