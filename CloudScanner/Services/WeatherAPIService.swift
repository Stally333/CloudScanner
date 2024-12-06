import Foundation
import CoreLocation

class WeatherAPIService {
    private let apiKey = APIConfig.openWeatherKey
    private let baseURL = APIConfig.baseURLs["weather"]!
    
    struct WeatherData: Codable {
        let clouds: CloudData
        let weather: [WeatherCondition]
        let main: MainData
        let wind: WindData
        let visibility: Int
        
        struct CloudData: Codable {
            let all: Int // Cloud coverage percentage
            let description: String?
        }
        
        struct WeatherCondition: Codable {
            let id: Int
            let main: String
            let description: String
        }
        
        struct MainData: Codable {
            let temp: Double
            let humidity: Int
            let pressure: Int
        }
        
        struct WindData: Codable {
            let speed: Double
            let deg: Int
        }
    }
    
    func getCurrentWeather(at location: CLLocation) async throws -> WeatherData {
        let urlString = "\(baseURL)/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(WeatherData.self, from: data)
    }
    
    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
    }
} 