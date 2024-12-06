import SwiftUI

struct WeatherInfoOverlay: View {
    let weather: WeatherService.ServiceWeatherData
    
    var body: some View {
        HStack(spacing: 12) {
            Label {
                Text("\(Int(weather.temperature))°")
            } icon: {
                Image(systemName: "thermometer")
            }
            
            Label {
                Text("\(Int(weather.humidity))%")
            } icon: {
                Image(systemName: "humidity")
            }
            
            Label {
                Text(weather.condition)
            } icon: {
                Image(systemName: weather.conditionIcon)
            }
        }
        .font(.caption)
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
} 