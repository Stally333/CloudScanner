import Foundation

struct WeatherData: Codable {
    let temperature: Double
    let humidity: Double
    let condition: String
    let conditionIcon: String
    let windSpeed: Double
    let windDirection: Int
    let pressure: Double
    let visibility: Double
    let isGoldenHour: Bool
    let isBlueMoment: Bool
    
    init(temperature: Double = 0,
         humidity: Double = 0,
         condition: String = "",
         conditionIcon: String = "cloud",
         windSpeed: Double = 0,
         windDirection: Int = 0,
         pressure: Double = 1013,
         visibility: Double = 10000,
         isGoldenHour: Bool = false,
         isBlueMoment: Bool = false) {
        self.temperature = temperature
        self.humidity = humidity
        self.condition = condition
        self.conditionIcon = conditionIcon
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.pressure = pressure
        self.visibility = visibility
        self.isGoldenHour = isGoldenHour
        self.isBlueMoment = isBlueMoment
    }
} 