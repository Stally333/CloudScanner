import SwiftUI

struct WeatherInfoView: View {
    let weather: WeatherService.WeatherData?
    
    var body: some View {
        HStack(spacing: 8) {
            // Temperature
            if let temp = weather?.temperature {
                Text("\(Int(temp))°")
                    .font(CloudFonts.headlineMedium)
            }
            
            // Cloud cover
            if let cloudCover = weather?.cloudCover {
                HStack(spacing: 4) {
                    Image(systemName: "cloud.fill")
                        .font(.caption)
                    Text("\(cloudCover)%")
                        .font(CloudFonts.caption)
                }
                .opacity(0.8)
            }
        }
        .foregroundColor(.white)
    }
} 