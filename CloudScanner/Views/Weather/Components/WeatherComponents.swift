import SwiftUI

// MARK: - Current Weather Components
struct CurrentWeatherCard: View {
    let weather: WeatherService.WeatherData
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(Int(weather.temperature))°")
                .font(.system(size: 72, weight: .thin))
            
            Text(weather.conditions.joined(separator: ", "))
                .font(.title2)
            
            HStack(spacing: 20) {
                WeatherDataRow(title: "Humidity", value: "\(Int(weather.humidity))%")
                WeatherDataRow(title: "Wind", value: "\(Int(weather.windSpeed)) m/s")
                WeatherDataRow(title: "Clouds", value: "\(weather.cloudCover)%")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct WeatherDataRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(CloudFonts.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(CloudFonts.headline)
        }
    }
}

struct CloudQualityBadge: View {
    let quality: CloudQuality
    
    var body: some View {
        Text(quality.rawValue)
            .font(CloudFonts.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(quality.color.opacity(0.2))
            .foregroundStyle(quality.color)
            .clipShape(Capsule())
    }
} 