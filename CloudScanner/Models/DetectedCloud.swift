import CoreGraphics

struct DetectedCloud {
    let bounds: CGRect
    let confidence: Float
    let type: CloudType
    
    enum CloudType: String {
        case cumulus = "Cumulus"
        case stratus = "Stratus"
        case cirrus = "Cirrus"
        case cumulonimbus = "Cumulonimbus"
        case altostratus = "Altostratus"
        case nimbostratus = "Nimbostratus"
        case unknown = "Unknown"
        
        var description: String {
            switch self {
            case .cumulus:
                return "Fair weather clouds"
            case .stratus:
                return "Low, uniform layer"
            case .cirrus:
                return "High-altitude ice clouds"
            case .cumulonimbus:
                return "Thunderstorm clouds"
            case .altostratus:
                return "Mid-level layer clouds"
            case .nimbostratus:
                return "Rain-bearing clouds"
            case .unknown:
                return "Analyzing cloud type"
            }
        }
        
        var weatherImplication: String {
            switch self {
            case .cumulus:
                return "Generally good weather"
            case .stratus:
                return "Overcast conditions likely"
            case .cirrus:
                return "Fair weather, may indicate approaching storm"
            case .cumulonimbus:
                return "Severe weather possible"
            case .altostratus:
                return "Precipitation likely approaching"
            case .nimbostratus:
                return "Continuous precipitation likely"
            case .unknown:
                return "Weather conditions uncertain"
            }
        }
        
        var altitude: String {
            switch self {
            case .cumulus, .stratus:
                return "Low altitude (0-6,500 ft)"
            case .altostratus:
                return "Mid altitude (6,500-23,000 ft)"
            case .cirrus:
                return "High altitude (>23,000 ft)"
            case .cumulonimbus:
                return "Multiple levels (0-60,000 ft)"
            case .nimbostratus:
                return "Low to mid altitude"
            case .unknown:
                return "Altitude unknown"
            }
        }
    }
} 