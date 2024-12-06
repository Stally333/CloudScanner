import SwiftUI

struct WeatherScoreCard: View {
    let weather: WeatherService.WeatherData
    
    var body: some View {
        VStack(spacing: 12) {
            // Score indicator
            ZStack {
                Circle()
                    .stroke(
                        Color.gray.opacity(0.2),
                        lineWidth: 10
                    )
                
                Circle()
                    .trim(from: 0, to: CGFloat(weather.photographyScore) / 100)
                    .stroke(
                        scoreColor,
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(weather.photographyScore)")
                        .font(.system(size: 32, weight: .bold))
                    Text("Score")
                        .font(CloudFonts.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 100, height: 100)
            
            // Conditions
            VStack(alignment: .leading, spacing: 8) {
                ConditionRow(
                    icon: "cloud.fill",
                    title: "Cloud Cover",
                    value: "\(weather.cloudCover)%"
                )
                ConditionRow(
                    icon: "eye.fill",
                    title: "Visibility",
                    value: String(format: "%.1f km", weather.visibility / 1000)
                )
                ConditionRow(
                    icon: "wind",
                    title: "Wind Speed",
                    value: String(format: "%.1f m/s", weather.windSpeed)
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
    
    private var scoreColor: Color {
        switch weather.photographyScore {
        case 80...: return .green
        case 60...: return .yellow
        default: return .orange
        }
    }
} 