import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published private(set) var currentConditions: WeatherService.CloudConditions?
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let weatherService = WeatherService.shared
    
    func updateWeather() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            currentConditions = try await weatherService.fetchCloudConditions()
        } catch {
            self.error = error
        }
    }
    
    var cloudTypeString: String {
        guard let conditions = currentConditions else { return "Unknown" }
        return conditions.primaryType
    }
    
    var cloudDescription: String {
        guard let conditions = currentConditions else { return "No cloud data available" }
        return conditions.description
    }
    
    func getCloudType() -> CloudPost.CloudType {
        guard let conditions = currentConditions else { return .unknown }
        switch conditions {
        case .clear: return .unknown
        case .partlyCloudy: return .cumulus
        case .cloudy: return .stratus
        case .overcast: return .nimbostratus
        }
    }
    
    var weatherSummary: String {
        guard let conditions = currentConditions else { return "Loading..." }
        return """
        Cloud Type: \(conditions.primaryType)
        Conditions: \(conditions.description)
        """
    }
} 