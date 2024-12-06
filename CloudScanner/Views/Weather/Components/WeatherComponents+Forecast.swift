import SwiftUI

struct ForecastCard: View {
    let data: WeatherService.ForecastData
    
    var body: some View {
        VStack(spacing: 8) {
            Text(data.time.formatted(.dateTime.hour()))
                .font(CloudFonts.caption)
            
            Image(systemName: data.symbolName)
                .font(.system(size: 24))
            
            Text("\(Int(data.temperature))°")
                .font(CloudFonts.body)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct ForecastView: View {
    let forecast: [WeatherService.ForecastData]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(forecast) { forecast in
                    ForecastCard(data: forecast)
                }
            }
            .padding(.horizontal)
        }
    }
} 