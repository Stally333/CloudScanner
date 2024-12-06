import SwiftUI

struct WeatherInfoBar: View {
    let weather: WeatherService.WeatherData?
    
    init(weather: WeatherService.WeatherData? = nil) {
        self.weather = weather
    }
    
    var body: some View {
        if let weather = weather {
            HStack(spacing: 16) {
                WeatherDataBadge(
                    icon: "thermometer",
                    value: "\(Int(weather.temperature))°"
                )
                
                WeatherDataBadge(
                    icon: "humidity",
                    value: "\(Int(weather.humidity))%"
                )
                
                WeatherDataBadge(
                    icon: "wind",
                    value: "\(Int(weather.windSpeed)) m/s"
                )
            }
            .font(CloudFonts.caption)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
} 